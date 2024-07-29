{ pkgs, username, ... }:
{
  imports = [
    ../applications/docker
    ../applications/bookmarks/navi.nix
    ../applications/bashmount.nix
    ../applications/git
    ../applications/shells
    ../applications/tmux.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    curl
    wget2
    wget
  ];

  home.stateVersion = "24.11";
}
