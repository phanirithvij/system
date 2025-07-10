{ pkgs, ... }:
{
  wrappers.wezterm = {
    basePackage = pkgs.lazyPkgs.wezterm;
    prependFlags = [
      "--config-file"
      ./wezterm.lua
    ];
  };
}
