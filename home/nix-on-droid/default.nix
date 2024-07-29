_: {
  imports = [
    ../applications/git
    ../applications/tmux.nix
    ../applications/bookmarks/navi.nix
    ../applications/shells
  ];
  home.username = "nix-on-droid";
  home.homeDirectory = "/data/data/com.termux.nix/files/home";
  home.stateVersion = "23.11";
}
