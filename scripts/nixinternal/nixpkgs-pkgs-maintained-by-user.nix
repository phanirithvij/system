# https://discourse.nixos.org/t/how-to-filter-nixpkgs-by-metadata/27473/10
{
  pkgs ? import (builtins.getFlake "github:nixos/nixpkgs") { },
  username ? "phanirithvij",
}:
let
  inherit (pkgs) lib;
  pkgMaintainers = pkg: pkg.meta.maintainers or [ ];
  userMaintains = pkg: builtins.elem pkgs.lib.maintainers.${username} (pkgMaintainers pkg);
  robustUserMaintains =
    pkg:
    let
      result = builtins.tryEval (userMaintains pkg);
    in
    if result.success then result.value else false;
  userMaintainsPackages = pkgs.lib.filterAttrs (_name: robustUserMaintains) pkgs;
  packages = lib.concatStringsSep "\n" (builtins.attrNames userMaintainsPackages);
in
packages
