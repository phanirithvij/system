{ pkgs, username, ... }:
let
  homeDir = "/home/${username}";
in
{
  imports = [
    ../applications/appimgs.nix
    ../applications/android.nix
    ../applications/audio
    ../applications/bookmarks
    ../applications/bashmount.nix
    ../applications/docker
    ../applications/editors.nix
    # TODO if inside specialization detect that?
    # maybe cfg.xfce enabled? something
    ../applications/config/xfconf.nix

    ../applications/games
    ../applications/git
    ../applications/go
    ../applications/media
    ../applications/nixy

    ../applications/hyprland.nix
    ../applications/rss.nix
    ../applications/shells
    ../applications/telegram
    ../applications/terminals.nix
    ../applications/tmux.nix
    ../applications/topgrade.nix
    ../applications/tui.nix

    ./home-scripts.nix
    ../../secrets
  ];

  home.username = username;
  home.homeDirectory = homeDir;

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    rclone
    yq
    viddy
    duf
    # dprint # use treefmt with it per project from now on

    #joplin # slow node tui app

    ctpv
    #xdragon

    glow # markdown previewer in terminal

    # TODO https://github.com/badele/nix-homelab/tree/main?tab=readme-ov-file#tui-floating-panel-configuration
    pulsemixer
    bluetuith
    devbox

    # desktop apps
    #microsoft-edge # for its bing ai integration (slow af)
    tor-browser
    telegram-desktop
    qbittorrent
    koreader
    qimgv
    beekeeper-studio
    yacreader
    localsend
    rclone-browser
    spotify

    ffmpeg-headless
    sqlite-interactive
    miniserve
    filebrowser
    cargo-update
    sccache
    cargo-binstall
    pipx
    trash-cli
    remote-touchpad

    # TODO remove this later when I know enough about python packages building with venv, poetry, devenv whatnot per project
    python3

    # TODO add this stuff
    #adb android-tools is too fat and heavy
    # rustdesk-server
    # templ
    # rustup
    # mise (rtx >> asdf-vm)
    # hyperfine
    # neovide
    # cargo-zigbuild
    # gping
    # gitoxide
    # du-dust
    # bore-cli
    # coreutils
    # onefetch
    # tokei
    # zig
    # goteleport
    #
    # caddy xcaddy with godaddy
    # nats
    # nats cli server
    # jellyfin
    # openspeedtestserver
    # TODO devbox
    # hare?
    # yadm? chezmoi? dotdrop etc all unncessary with nix I think?
    # ntfy-sh
  ];

  programs.bottom.enable = true;
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 11.25;
        normal = {
          family = "JetBrainsMono Nerd Font"; # TODO try Source Code Pro
        };
      };
    };
  };
  programs.aria2.enable = true;
  programs.bun.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global.disable_stdin = true;
      global.strict_env = true;
      global.hide_env_diff = true;
    };
  };

  programs.firefox.enable = true;
  programs.gallery-dl.enable = true;
  programs.jq.enable = true;

  programs.poetry.enable = true;

  programs.ripgrep.enable = true;

  programs.yt-dlp.enable = true;

  home.file.".cargo/config.toml".text = ''
    [registries.crates-io]
    protocol = "sparse"

    [build]
    rustc-wrapper = "sccache"
  '';

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
