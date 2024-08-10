{ lib, pkgs, ... }:
{
  specialisation.rat = {
    inheritParentConfig = true;
    configuration = {
      services = {
        xserver.windowManager.ratpoison.enable = true;
        desktopManager.plasma6.enable = lib.mkForce false;
      };
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = "*";
      };
    };
  };
}
