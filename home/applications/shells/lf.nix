{ pkgs, ... }:
{
  home.packages = [ pkgs.wrappedPkgs.lf ];
}
