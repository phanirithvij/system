{
  flake-inputs,
  lib,
  system,
  ...
}:
let
  #debug = lib.traceSeq (builtins.attrNames flake-inputs.nur-pkgs.packages.${system}) f;
  f = builtins.attrValues (
    (lib.attrsets.filterAttrs (
      n: _:
      !builtins.elem n [
        "overlayShell"
        "unstablePkgs"
        # broken
        "feedpushr"
      ]
    ) flake-inputs.nur-pkgs.packages.${system})
    // flake-inputs.nur-pkgs.packages.${system}.unstablePkgs
  );
in
{
  home.packages = f;
}
