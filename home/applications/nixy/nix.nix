{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #nix-output-monitor #need an unstable version, moved to nur
    nvd
    #nh #needs newer nom, moved to nur
  ];
}
