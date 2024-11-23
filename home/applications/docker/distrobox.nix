{ pkgs, lib, ... }:
{
  home.packages = [
    pkgs.distrobox
    # since distrobox-tui-dev is the one I develop
    (lib.lowPrio pkgs.distrobox-tui)
  ];
}
