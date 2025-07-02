{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wrappedPkgs.wezterm
    nurPkgs.flakePkgs.ghostty
  ];
}
