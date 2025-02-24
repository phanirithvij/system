{
  flake-inputs,
  lib,
  system,
  ...
}:
let
  #debug = lib.traceSeq (builtins.attrNames flake-inputs.nur-pkgs.packages.${system}) f;
  f = builtins.attrValues (
    lib.attrsets.filterAttrs (
      n: _:
      !builtins.elem n [
        "overlayShell"
        "unstablePkgs" # but it doesn't show up in packages.${system}

        # broken
        "feedpushr"
      ]
    ) flake-inputs.nur-pkgs.packages.${system}
  );
in
{
  home.packages = f;
}
