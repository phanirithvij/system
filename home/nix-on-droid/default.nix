{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.lazygit.enable = true;
  programs.tmux.enable = true;
  home.stateVersion = "23.11";
}
