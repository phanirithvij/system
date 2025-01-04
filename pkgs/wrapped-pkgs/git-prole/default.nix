{ pkgs, ... }:
{
  wrappers.git-prole = {
    basePackage = pkgs.git-prole;
    flags = [
      "--config"
      ./config.toml
    ];
  };
}
