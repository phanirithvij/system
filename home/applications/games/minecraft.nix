{ pkgs, ... }:
{
  ## prismlauncher
  # unmined
  home.packages = with pkgs; [
    prismlauncher
    steam-run
  ];
}
