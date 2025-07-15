{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lazyPkgs.syncplay
    playerctl
    wrappedPkgs.mpv
  ];
}
