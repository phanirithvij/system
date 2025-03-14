{ lib, ... }:
{
  specialisation.niri = {
    inheritParentConfig = true;
    configuration = {
      desktopManagers.niri.enable = true;
      desktopManagers.xfce.enable = lib.mkForce false;
    };
  };
}
