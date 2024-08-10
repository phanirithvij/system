{ pkgs, ... }:
{
  home.packages = [
    pkgs.tdl
    pkgs.telegram-desktop
  ];
}
