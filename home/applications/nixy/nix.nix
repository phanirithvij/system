{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #nix-output-monitor #need an unstable version
    nvd
    nh
  ];
}
