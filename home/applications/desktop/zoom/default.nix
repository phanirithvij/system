{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lazyPkgs.zoom-us
  ];
}
