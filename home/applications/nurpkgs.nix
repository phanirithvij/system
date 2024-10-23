{ flake-inputs, system, ... }:
{
  # ensure they all build?
  home.packages = builtins.attrValues flake-inputs.nur-pkgs.packages.${system};
}
