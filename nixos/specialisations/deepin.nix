{ lib, ... }:
{
  specialisation.deepin = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:deepin" ];
      services.xserver.desktopManager.deepin.enable = true;
      desktopManagers.xfce.enable = lib.mkForce false;
    };
  };
}
