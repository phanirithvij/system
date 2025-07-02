{ pkgs, ... }:
{
  imports = [ ./nix.nix ];
  home.packages = with pkgs; [
    compose2nix
    pr-tracker
    nurPkgs.flakePkgs.yaml2nix
  ];
}
