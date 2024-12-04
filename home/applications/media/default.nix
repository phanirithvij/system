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
      save-position-on-quit = true;
    };
    # https://github.com/mpv-player/mpv/blob/master/etc/input.conf
    bindings = {
      A = ''cycle-values video-aspect-override "2.35:1" "-1"'';
      "ctrl+k" = "add sub-scale +0.1";
      "ctrl+j" = "add sub-scale -0.1";
      t = "script-message-to seek_to toggle-seeker";
    };
    scripts = with pkgs.mpvScripts; [
      thumbfast
      uosc
      seekTo
    ];
  };
}
