{ pkgs, lib, ... }:
{
  home.packages = [
    pkgs.distrobox
    (lib.lowPrio pkgs.distrobox-tui)
  ];
}
