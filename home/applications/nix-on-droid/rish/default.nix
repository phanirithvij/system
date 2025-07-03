# NOTE: this file exists primarily for nix-update to work
{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  rish = pkgs.callPackage ./package.nix { };
}
