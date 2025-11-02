{ pkgs, ... }:
{
  imports = [ ./nix.nix ];
  home.packages = with pkgs; [
    compose2nix
    #pr-tracker #should be autoadded via nurpkgs
    nurPkgs.flakePkgs.yaml2nix
  ];
}
