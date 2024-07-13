{ pkgs, ... }:
{
  home.packages = [
    pkgs.syncplay
    pkgs.playerctl
  ];
  programs.mpv = {
    enable = true;
    config = {
      auto-window-resize = false;
    };
    scripts = with pkgs; [ mpvScripts.uosc ];
  };
}
