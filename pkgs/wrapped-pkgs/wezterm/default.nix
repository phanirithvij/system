{ pkgs, ... }:
{
  wrappers.wezterm = {
    basePackage = pkgs.wezterm;
    prependFlags = [
      "--config-file"
      ./wezterm.lua
    ];
  };
}
