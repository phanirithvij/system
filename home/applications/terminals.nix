{ pkgs, ... }:
{
  home.packages = [ pkgs.wrappedPkgs.wezterm ];
}
