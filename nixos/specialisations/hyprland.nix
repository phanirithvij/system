{ lib, ... }:
{
  specialisation.hyprland = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:hyprland" ];
      desktopManagers.hyprland.enable = true;
      desktopManagers.xfce.enable = lib.mkForce false;
    };
  };
}
