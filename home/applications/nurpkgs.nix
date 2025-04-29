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
        "feedpushr" # broken
        "nixpkgs-track" # wrappedPkgs, don't use direct
      ]
    ) flake-inputs.nur-pkgs.packages.${system})
    // flake-inputs.nur-pkgs.packages.${system}.unstablePkgs
  );
in
{
  home.packages = f;
}
