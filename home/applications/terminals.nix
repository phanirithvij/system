{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wrappedPkgs.wezterm
    lazyPkgs.ghostty
  ];
}
