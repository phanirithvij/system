{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    package = pkgs.wrappedPkgs.tmux;
  };
  programs.tmux-aliases.enable = true;

  /*
    TODO when I know more about nix
    aliases.tmux = {
      pkg = pkgs.wrappedPkgs.tmux;
      t = "tmux";
      ta = "tmux a";
      at = "tmux a";
      tma = "tmux a";
    };
  */

  home.packages = [ pkgs.sesh ];
  # tmuxp
  # dmux
  # tmate?
}
