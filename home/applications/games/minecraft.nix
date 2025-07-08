{ pkgs, ... }:
{
  # TODO unmined
  home.packages = with pkgs; [
    lazyPkgs.prismlauncher
    lazyPkgs.steam-run
  ];
}
