{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktopManagers.xfce.enable = lib.mkEnableOption "Enable xfce desktopManager";
  config = lib.mkIf config.desktopManagers.xfce.enable {
    services.xserver.desktopManager.xfce.enable = true;
    services.xserver.desktopManager.xfce.enableScreensaver = false;
    environment.systemPackages = with pkgs; [
      plata-theme
      # TODO rofi custom theme, keybinds
      # xfce independant!
      rofi
      # Need to bring xfce to my previous workflow
      # [ ] super key for search / whiskermenu
      #    ctrl+esc is the workaround
      # [x] espanso alt+space
      # [x] super+num
      #    docklike plugin
      #    - [ ] track w/ yadm, or home-manager with read/write to allow visual modification
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      xfce.xfce4-whiskermenu-plugin
      xfce.xfce4-clipman-plugin
      xfce.xfce4-panel-profiles

      # https://www.reddit.com/r/xfce/comments/yya1j6/comment/iwu1okj
      # https://www.reddit.com/r/xfce/comments/ibx257/windows_number_shortcut
      # https://github.com/nsz32/docklike-plugin/issues/145
      # shift+click
      # ctrl+drag+drop
      (xfce.xfce4-docklike-plugin.overrideAttrs (_: {
        patches = [ ./docklike-settings.patch ];
      }))
    ];
    programs.xfconf.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };
    services.blueman.enable = true; # by default no bt gui
  };
}
