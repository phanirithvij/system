{ pkgs, username, ... }:
{
  imports = [
    ../../applications/git
    ../../applications/shells
    ../../applications/bashmount.nix
    ../../applications/bookmarks
    ../../applications/nixy/nix.nix
    ../../applications/tmux.nix

    ../../../secrets
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
