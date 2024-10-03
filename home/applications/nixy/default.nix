{ pkgs, ... }:
{
  imports = [ ./nix.nix ];
  home.packages = [
    pkgs.compose2nix
    pkgs.pr-tracker
  ];
}
