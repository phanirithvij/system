{ pkgs, ... }:
{
  home.file.".tmux/resize-hook.sh".source = ./config/tmux/resize-hook.sh;
  home.file.".tmux.conf".source = ./config/tmux/.tmux.conf;
  programs.tmux.enable = true;

  home.packages = [ pkgs.sesh ];
  # tmuxp
  # dmux
  # tmate?
}
