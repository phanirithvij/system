{ flake-inputs, system, ... }:
{
  # ensure they all build?
  # TODO ignore unstablePkgs
  home.packages = builtins.attrValues flake-inputs.nur-pkgs.packages.${system};
}
