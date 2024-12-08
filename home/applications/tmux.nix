{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    package = pkgs.wrappedPkgs.tmux;
  };

  home.packages = [ pkgs.sesh ];
  # tmuxp
  # dmux
  # tmate?
}
