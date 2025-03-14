{ lib, ... }:
{
  specialisation.cinnamon = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:cinnamon" ];
      desktopManagers.cinnamon.enable = true;
      desktopManagers.xfce.enable = lib.mkForce false;
    };
  };
}
