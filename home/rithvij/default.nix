{ pkgs, username, ... }:
let
  homeDir = "/home/${username}";
in
{
  imports = [
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
    ../applications/tcount.nix
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
    gdu
    # dprint # use treefmt with it per project from now on

    #joplin # slow node tui app

    #ctpv

    glow # markdown previewer in terminal

    # TODO https://github.com/badele/nix-homelab/tree/main?tab=readme-ov-file#tui-floating-panel-configuration
    pulsemixer
    bluetuith
    devbox

    # desktop apps
    #microsoft-edge # for its bing ai integration (slow af)
    tor-browser
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
    miniserve # httplz -x
    filebrowser # service maybe?
    cargo-update # needed?
    sccache # needed?
    cargo-binstall # needed?
    pipx # needed?
    trash-cli # there is a rustrewrite for this, trashy maybe
    remote-touchpad

    python3

    # https://discourse.nixos.org/t/home-manager-collision-with-app-lib/51969
    # https://haseebmajid.dev/posts/2023-10-02-til-how-to-fix-package-binary-collisions-on-nix/
    (lib.hiPrio rustdesk-flutter)
    subtitlecomposer

    # TODO add this stuff
    #adb android-tools is too fat and heavy
    # rustdesk-server
    # mise (rtx >> asdf-vm)
    # templ, hyperfine # perproject
    # neovide
    # cargo-zigbuild
    # zig
    # gping
    # gitoxide
    # du-dust
    # bore-cli
    # coreutils
    # onefetch, tokei, scc
    # goteleport
    #
    # caddy xcaddy with godaddy
    # nats
    # nats cli server
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
        size = 14.25;
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

  xdg.mimeApps =
    let
      ff = {
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      };
    in
    {
      enable = true;
      defaultApplications = ff;
      associations.added = ff;
    };
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
