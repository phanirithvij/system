{
  inputs,
  pkgs,
  hostname,
  username,
  ...
}:
{

  imports = [
    ../applications/git
    ../applications/shells
    ../applications/bashmount.nix
    ../applications/bookmarks/navi.nix
    ../applications/tmux.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    curl
    wget2
  ];

  home.stateVersion = "24.11";
}
