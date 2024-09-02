{ pkgs, ... }:
{
  xdg.configFile."hypr/hyprland.conf".source = ./config/hypr/hyprland.conf;
  xdg.configFile."hypr/monitors.conf".source = ./config/hypr/monitors.conf;
  xdg.configFile."hypr/workspaces.conf".source = ./config/hypr/workspaces.conf;
  /*
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${./config/wall.jpg}
      wallpaper = ,${./config/wall.jpg}
      ipc = off
    '';
  */
  xdg.configFile."waybar".source = ./config/waybar;
  xdg.configFile."wofi".source = ./config/wofi;
  home.packages = [
    pkgs.wl-clipboard-rs
    pkgs.cliphist
    pkgs.wofi
    pkgs.waybar
    #pkgs.hyprpaper
    pkgs.networkmanagerapplet
  ];
}
