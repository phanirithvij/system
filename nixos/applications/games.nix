{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.steam.enable = true;
  programs.steam.package = pkgs.lazyPkgs.steam;
  environment.systemPackages = [
    (lib.mine.GPUOffloadApp config.programs.steam.package "steam")
  ];
}
