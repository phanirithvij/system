{ pkgs, ... }:
{
  xdg.configFile."hypr".source = ./config/hypr;
  xdg.configFile."waybar".source = ./config/waybar;
  xdg.configFile."wofi".source = ./config/wofi;
  home.packages = [
    pkgs.wl-clipboard-rs
    pkgs.cliphist
    pkgs.wofi
    pkgs.waybar
    pkgs.hyprpaper
    pkgs.networkmanagerapplet
  ];
}
