{ pkgs, ... }:
{
  # unmined
  home.packages = with pkgs; [
    prismlauncher
    steam-run
  ];
}
