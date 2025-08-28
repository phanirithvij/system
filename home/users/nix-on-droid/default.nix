{
  pkgs, # BUG, remove pkgs here and it won't show up in args.pkgs
  config,
  username,
  ...
}@args:
{
  imports = [
    (import ../../applications/bookmarks/navi.nix (
      args
      // {
        inherit pkgs;
        wifipassFile = config.sops.secrets.wifi_password_file.path;
      }
    ))
    ../../applications/direnv.nix
    ../../applications/git
    ../../applications/go
    ../../applications/nixy/nix.nix
    ../../applications/shells
    ../../applications/tmux.nix

    ./home-scripts.nix

    ../../../secrets
  ];

  # redefined for nix-on-droid user, to avoid espanso
  # TODO espanso and navi should be decoupled
  sops.secrets.wifi_password_file = { };

  home.packages = with pkgs; [
    ripgrep
    jq
    fx
  ];

  home.username = username;
  home.homeDirectory = "/data/data/com.termux.nix/files/home";
  home.stateVersion = "24.11";
}
