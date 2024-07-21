{ lib, pkgs, ... }:
{
  specialisation = {
    xfce = {
      inheritParentConfig = true;
      configuration = {
        xdg.portal = {
          enable = true;
          gtkUsePortal = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        };
        services.xserver.desktopManager.xfce.enable = true;
        services.desktopManager.plasma6.enable = lib.mkForce false;
        environment.systemPackages = with pkgs; [
          plata-theme
          rofi
          xfce.thunar
          xfce.xfce4-whiskermenu-plugin
        ];
        programs.xfconf.enable = true;
      };
    };
  };

}
