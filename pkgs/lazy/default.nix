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
  lazyPkgs = lib.concatMapAttrs (
    n: v: lib.attrsets.setAttrByPath (lib.path.subpath.components n) (import ./${v}.nix cargs)
  ) packages;
in
lazyPkgs
