{ pkgs, ... }:
{
  home.packages = [
    pkgs.fx
    pkgs.lazyPkgs.puffin
    pkgs.lazyPkgs.hledger
  ];
  # TODO redis tui
  # TODO k9s
  # etc.
}
