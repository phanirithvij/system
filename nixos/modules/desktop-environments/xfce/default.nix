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
    # TODO overlay better? https://github.com/breitnw/nixos/blob/main/home/breitnw/gui-programs/parole.nix
    environment.xfce.excludePackages = [ pkgs.parole ]; # overriden below
    environment.systemPackages = with pkgs; [
      # Add h264 support for parole media player
      (parole.overrideAttrs (p: {
        buildInputs = p.buildInputs ++ [
          pkgs.gst_all_1.gst-libav
        ];
      }))
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
      thunar
      thunar-volman
      thunar-archive-plugin
      xfce4-whiskermenu-plugin
      xfce4-clipman-plugin
      xfce4-panel-profiles

      # https://www.reddit.com/r/xfce/comments/yya1j6/comment/iwu1okj
      # https://www.reddit.com/r/xfce/comments/ibx257/windows_number_shortcut
      # https://github.com/nsz32/docklike-plugin/issues/145
      # shift+click
      # ctrl+drag+drop
      (xfce4-docklike-plugin.overrideAttrs (_: {
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
