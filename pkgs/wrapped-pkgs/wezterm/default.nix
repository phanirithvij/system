{ pkgs, ... }:
{
  wrappers.wezterm = {
    basePackage = pkgs.wezterm;
    flags = [
      "--config-file"
      ./wezterm.lua
    ];
  };
}
