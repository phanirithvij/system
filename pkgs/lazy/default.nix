# NOTE: use file imports only for packages not in nixpkgs
{
  lib ? pkgs.lib,
  pkgs ? import <nixpkgs> { },
  system ? "x86_64-linux",
  flake-inputs ? {
    lazy-apps.packages.${system}.lazy-app =
      (
        # IFD? what about npins imports?
        (import (
          pkgs.fetchFromGitHub {
            owner = "phanirithvij";
            repo = "lazy-apps";
            rev = "master";
            hash = "sha256-cXSYhGgnMBgNesS8vT4S24ipAY0p6mzvt7eTemQqblM=";
          }
        )).mkLazyApps
          { inherit pkgs; }
      ).lazy-app;
  },
  repl ? false, # cd pkgs/lazy; nix repl -f default.nix --arg repl true
}@args:
let
  inherit (flake-inputs.lazy-apps.packages.${system}) lazy-app;
  cargs = args // {
    inherit mkLazyApp;
  };

  desktopItems = lib.fileset.toSource {
    fileset = lib.fileset.fileFilter (file: file.hasExt "desktop") ./desktopItems;
    root = ./desktopItems;
  };

  getDesktopItems =
    name:
    lib.optional (builtins.pathExists "${desktopItems}/${name}.desktop") "${desktopItems}/${name}.desktop"
    ++ lib.optionals (builtins.pathExists "${desktopItems}/${name}") (
      lib.filesystem.listFilesRecursive "${desktopItems}/${name}"
    );

  mkLazyApp =
    { pkg, ... }@args:
    let
      exe = args.exe or lPkg.exeName;
      desktopItems = getDesktopItems exe;
      lPkg = lazy-app.override (
        {
          inherit pkg desktopItems;
        }
        // (removeAttrs args [ "exe" ]) # override desktopItems from args
      );
    in
    lPkg;

  # TODO desktop icons how....
  # check if original package hash desktop icons defined and copy that?
  # but why didn't upstream (lazy-apps) do that then?
  pkgsList = [
    # "cabal-install"
    # "nixGL" # TODO flake?
    "a-keys-path"
    "android-file-transfer"
    "antimicrox"
    "bandwhich"
    "blobdrop"
    "bottom"
    "bun"
    "chezmoi"
    "cloudflare-warp"
    "devbox"
    "expect"
    "feh"
    "figlet"
    "fq"
    "fx"
    "gamescope"
    "gitui"
    "go"
    "heroic"
    "hledger"
    "iredis"
    "joplin"
    "k3s"
    "k9s"
    "kind"
    "kubectl"
    "lazysql"
    "lgogdownloader"
    "ludusavi"
    "lynis"
    "neovide"
    "nethogs"
    "nitrogen"
    "n-m3u8dl-re"
    "oh-my-git"
    "onboard"
    "puffin"
    "prismlauncher"
    "python3.pkgs.gdown" # can be just gdown
    "qpwgraph"
    "rclone-browser"
    "scrcpy"
    "steam"
    "steam-run"
    "syncplay"
    "tdl"
    "telegram-desktop"
    "termshark"
    "tesseract"
    "tg-archive"
    "tmsu"
    "tym"
    "variety"
    "vhs"
    "w3m"
    "wezterm"
    "zenith"

    # losslesscut # temp disable for nod
    "beekeeper-studio"
    "localsend"
    "koreader"
    "tor-browser"
    "yacreader"
  ];

  combine = lib.foldl (a: b: lib.recursiveUpdate a b) { };
  listNixfilesInDir =
    /*
      e.g. {
        "nixUtils/nix-tree" = "nixUtils/nix-tree";
        "tesseract" = "tesseract";
      }
    */
    dir:
    lib.pipe (lib.filesystem.listFilesRecursive dir) [
      (builtins.filter (
        f:
        lib.hasSuffix "nix" f
        && !(lib.hasSuffix "default.nix" f)
        && !(lib.hasSuffix "bundle-lazy-apps.nix" f)
      ))
      (map builtins.toString)
      (map (lib.removeSuffix ".nix"))
      (map (s: lib.removePrefix "${builtins.toString dir}/" s))
    ];
  packages = lib.genAttrs (listNixfilesInDir ./.) lib.id;
  nixpkgsPkgs = lib.listToAttrs (
    builtins.map (name: {
      inherit name;
      value = mkLazyApp {
        pkg = lib.getAttrFromPath (lib.splitString "." name) pkgs;
        exe = name;
      };
    }) pkgsList
  );
  lazyPkgs = combine (
    lib.attrValues (
      lib.mapAttrs (
        n: v: lib.attrsets.setAttrByPath (lib.path.subpath.components n) (import ./${v}.nix cargs)
      ) packages
    )
  );
in
if repl then
  {
    inherit
      lib
      packages
      pkgsList
      lazyPkgs
      mkLazyApp
      nixpkgsPkgs
      desktopItems
      getDesktopItems
      ;
  }
else
  nixpkgsPkgs // lazyPkgs
