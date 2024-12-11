{ lib, ... }:
{
  specialisation.cinnamon = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:cinnamon" ];
      services.xserver.desktopManager.cinnamon.enable = true;
      services.desktopManager.plasma6.enable = lib.mkForce false;
      services.displayManager.ly.enable = lib.mkForce false;
      services.xserver.displayManager.gdm.enable = lib.mkForce true;
    };
  };
}
