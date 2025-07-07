{ config, lib, ... }:
{
  programs.steam.enable = true;
  environment.systemPackages = [
    (lib.mine.GPUOffloadApp config.programs.steam.package "steam")
  ];
}
