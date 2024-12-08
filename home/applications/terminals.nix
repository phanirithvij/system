{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    package = pkgs.wrappedPkgs.wezterm;
  };
}
