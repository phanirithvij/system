{ pkgs, ... }:
{
  wrappers.git-prole = {
    basePackage = pkgs.git-prole;
    prependFlags = [
      "--config"
      ./config.toml
    ];
  };
}
