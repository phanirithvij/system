# NOTE: use file imports only for packages not in nixpkgs
{
  flake-inputs,
  pkgs,
  system,
  ...
}@args:
let
  inherit (pkgs) lib;
  inherit (flake-inputs.lazy-apps.packages.${system}) lazy-app;
  cargs = args // {
    inherit lazy-app;
  };

  pkgsList = with pkgs; [
    # cabal-install
    # nixGL # TODO flake?
    antimicrox
    bandwhich
    bottom
    chezmoi
    expect
    feh
    figlet
    fq
    gitui
    hledger
    k3s
    k9s
    kind
    kubectl
    lynis
    neovide
    nethogs
    nitrogen
    onboard
    puffin
    python3.pkgs.gdown
    termshark
    tesseract
    tmsu
    tym
    variety
    vhs
    w3m
    zenith
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
      (builtins.filter (f: lib.hasSuffix "nix" f && !(lib.hasSuffix "default.nix" f)))
      (map builtins.toString)
      (map (lib.removeSuffix ".nix"))
      (map (s: lib.removePrefix "${builtins.toString dir}/" s))
    ];
  packages = lib.genAttrs (listNixfilesInDir ./.) (i: i);
  nixpkgsPkgs = lib.listToAttrs (
    builtins.map (
      pkg:
      let
        exe = lazy-app.override { inherit pkg; };
      in
      {
        name = exe.exeName;
        value = exe;
      }
    ) pkgsList
  );
  lazyPkgs = lib.concatMapAttrs (
    n: v: lib.attrsets.setAttrByPath (lib.path.subpath.components n) (import ./${v}.nix cargs)
  ) packages;
in
nixpkgsPkgs // lazyPkgs
