{ flake-inputs, system, ... }:
{
  wrappers.git-prole = {
    basePackage = flake-inputs.git-prole.packages.${system}.default;
    flags = [
      "--config"
      ./config.toml
    ];
  };
}
