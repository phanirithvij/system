{ pkgs, ... }:
{
  imports = [ ./nix.nix ];
  home.packages = [ pkgs.pr-tracker ];
}
