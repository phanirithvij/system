{ lib, ... }:
{
  specialisation.cinnamon = {
    inheritParentConfig = true;
    configuration = {
      services.xserver.desktopManager.cinnamon.enable = true;
      services.desktopManager.plasma6.enable = lib.mkForce false;
      services.displayManager.ly.enable = lib.mkForce false;
      services.xserver.displayManager.gdm.enable = lib.mkForce true;
    };
  };
}
