{ pkgs, wrappedPkgs, ... }:
{
  programs.tmux = {
    enable = true;
    package = wrappedPkgs.tmux;
  };

  home.packages = [ pkgs.sesh ];
  # tmuxp
  # dmux
  # tmate?
}
