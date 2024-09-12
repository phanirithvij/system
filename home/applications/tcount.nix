{
  pkgs,
  lib,
  ...
}:
let
  tcount = pkgs.callPackage ../../pkgs/tcount.nix {
    inherit lib;
    inherit (pkgs) rustPlatform fetchFromGitHub;
  };
in
{
  home.packages = [ tcount ];
}
