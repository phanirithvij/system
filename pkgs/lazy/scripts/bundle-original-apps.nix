{
  gitRoot,
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
}:
let
  flk = builtins.getFlake (toString gitRoot);
  lazyApps = flk.lazyApps.${builtins.currentSystem};
  getApplications = _pname: pkg: pkg.pkg;
  paths = lib.attrValues (lib.mapAttrs getApplications lazyApps);
in
pkgs.buildEnv {
  name = "bundle-lazy-desktop-items";
  inherit paths;
  # in nixpkgs/nixos/modules/config/xdg
  pathsToLink = [
    "/share/mime"

    "/share/icons"
    "/share/pixmaps"

    "/share/applications"
    "/share/desktop-directories"
    "/etc/xdg/menus"
    "/etc/xdg/menus/applications-merged"

    "/share/fish"
    "/share/bash-completions"
    "/share/zsh"
    "/share/nushell"
  ];
}
