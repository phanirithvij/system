{
  flake-inputs,
  lib,
  system,
  ...
}:
{
  home.packages = builtins.attrValues (
    lib.attrsets.filterAttrs (
      n: _:
      !builtins.elem n [
        "overlayShell"
        "unstablePkgs" # but it doesn't show up in packages.${system}
      ]
    ) flake-inputs.nur-pkgs.packages.${system}
  );
}
