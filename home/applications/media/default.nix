{ pkgs, ... }:
{
  home.packages = [
    pkgs.syncplay
    pkgs.playerctl
  ];
  # TODO eliminate home-manager managed mpv
  # ideally home-manager shouldn't exist, it should be a one step deployment
  programs.mpv = {
    package = pkgs.wrappedPkgs.mpv;
    enable = true;
  };
}
