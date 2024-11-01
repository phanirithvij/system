{ pkgs, username, ... }:
{
  imports = [
    ../applications/docker
    ../applications/bashmount.nix
    ../applications/tmux.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    curl
    wget2
    wget
    sysz
  ];

  home.stateVersion = "24.11";
}
