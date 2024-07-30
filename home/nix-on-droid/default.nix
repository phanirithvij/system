_: {
  imports = [
    ../applications/bookmarks/navi.nix
    ../applications/git
    ../applications/nix.nix
    ../applications/shells
    ../applications/tmux.nix
  ];
  home.username = "nix-on-droid";
  home.homeDirectory = "/data/data/com.termux.nix/files/home";
  home.stateVersion = "23.11";
}
