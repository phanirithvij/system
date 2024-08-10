{ pkgs, ... }:
{
  home.packages = [
    pkgs.distrobox
    pkgs.distrobox-tui
  ];
}
