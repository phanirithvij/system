{ config, ... }@args:
{
  imports = [
    (import ../../applications/bookmarks/navi.nix (
      args
      // {
        wifipassFile = config.sops.secrets.wifi_password_file.path;
      }
    ))
    ../../applications/git
    ../../applications/go
    ../../applications/nixy/nix.nix
    ../../applications/shells
    ../../applications/tmux.nix
  ];

  # redefined for nix-on-droid user, to avoid espanso
  # TODO espanso and navi should be decoupled
  sops.secrets.wifi_password_file = { };

  home.username = "nix-on-droid";
  home.homeDirectory = "/data/data/com.termux.nix/files/home";
  home.stateVersion = "24.11";
}
