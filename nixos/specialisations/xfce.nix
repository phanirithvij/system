{ lib, ... }:
{
  specialisation.xfce = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:xfce" ];
      desktopManagers.xfce.enable = lib.mkDefault true;
    };
  };
}
