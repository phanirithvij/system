{ pkgs, ... }:
{
  wrappers.dprint = {
    basePackage = pkgs.dprint;
    flags = [
      "--config"
      ./dprint.json
    ];
  };
}
