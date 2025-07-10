# NOTE: use file imports only for packages not in nixpkgs
{
  lib,
  pkgs,
  system,
  flake-inputs,
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
    lib.optional (builtins.pathExists (./desktopItems + "/${name}.desktop")) (
      desktopItems + "/${name}.desktop"
    )
    ++ lib.optionals (builtins.pathExists (./desktopItems + "/${name}")) (
      let
        items = lib.fileset.toList (
          lib.fileset.fileFilter (file: file.hasExt "desktop") ./desktopItems/${name}
        );
      in
      map (
        item:
        lib.fileset.toSource {
          fileset = item;
          root = ./desktopItems/${name};
        }
      ) items
    );

  mkLazyApp =
    { pkg, ... }@args:
    let
      desktopItems = getDesktopItems lPkg.exeName;
      lPkg = lazy-app.override (
        {
          inherit pkg desktopItems;
        }
        // args # override desktopItems from args
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
    "devbox"
    "expect"
    "feh"
    "figlet"
    "fq"
    "gamescope"
    "gitui"
    "heroic"
    "hledger"
    "joplin"
    "k3s"
    "k9s"
    "kind"
    "kubectl"
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
    "python3.pkgs.gdown" # can be just gdown
    "rclone-browser"
    "scrcpy"
    "steam"
    "termshark"
    "tesseract"
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
      value = mkLazyApp { pkg = lib.getAttrFromPath (lib.splitString "." name) pkgs; };
    }) pkgsList
  );
  lazyPkgs = lib.concatMapAttrs (
    n: v: lib.attrsets.setAttrByPath (lib.path.subpath.components n) (import ./${v}.nix cargs)
  ) packages;
in
nixpkgsPkgs // lazyPkgs
