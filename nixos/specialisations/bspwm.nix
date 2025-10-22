{ lib, pkgs, ... }:
{
  specialisation.bspwm = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:bspwm" ];
      services.xserver.windowManager.bspwm.enable = true;
      desktopManagers.xfce.enable = lib.mkForce false;
      environment.systemPackages = with pkgs; [
        dunst
        rofi
      ];
    };
  };
}
