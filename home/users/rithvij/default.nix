{ pkgs, username, ... }:
let
  homeDir = "/home/${username}";
in
{
  imports = [
    ../../applications/android.nix
    ../../applications/audio
    ../../applications/bookmarks
    ../../applications/bashmount.nix
    ../../applications/docker
    ../../applications/editors

    ../../applications/jj
    ../../applications/games
    ../../applications/git
    ../../applications/go
    ../../applications/media
    ../../applications/nixy

    ../../applications/nurpkgs.nix

    ../../applications/gui.nix
    ../../applications/hyprland.nix
    ../../applications/rss.nix
    ../../applications/shells
    ../../applications/telegram
    ../../applications/terminals.nix
    ../../applications/tmux.nix
    ../../applications/topgrade.nix
    ../../applications/tui.nix

    ../../applications/heavy.nix

    ./home-scripts.nix
    ../../../secrets

    ../../services/password_manager.nix

    ../../specialisations
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
    #rclone #tgdrive version from nur
    yq
    duf
    gdu
    # dprint # use treefmt with it per project from now on

    #joplin # slow node tui app

    #ctpv
    blobdrop

    glow # markdown previewer in terminal
    python3Packages.grip # markdown preview in browser

    # TODO https://github.com/badele/nix-homelab/tree/main?tab=readme-ov-file#tui-floating-panel-configuration
    pulsemixer
    bluetuith
    bluetui
    #overskride

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
    lazyPkgs.spotify

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
    #redbean ape com

    python3
    libnotify # notify-send
    # TODO dunst

    # https://discourse.nixos.org/t/home-manager-collision-with-app-lib/51969
    # https://haseebmajid.dev/posts/2023-10-02-til-how-to-fix-package-binary-collisions-on-nix/
    # (lib.hiPrio rustdesk-flutter) # BROKEN, TODO later
    (subtitlecomposer.overrideAttrs (_: {
      version = "0-unstable-2024-12-05";
      src = fetchFromGitLab {
        domain = "invent.kde.org";
        owner = "multimedia";
        repo = "subtitlecomposer";
        rev = "dbe98938bcd82f19b8bc871a54e694b722d470b4";
        hash = "sha256-VcTyaiVtiyb1unZYb9lWAStC9D1p0OkCW1IRwPtqBTg=";
      };
    }))

    n-m3u8dl-re

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
    # onefetch, tokei, scc, tcount
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
        size = 12.25;
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

  # TODO firefox with extensions configure
  # Ensures impurity can't exist by restricting extensions from being installed
  # Librewolf etc? mozilla is getting enshittified
  # chrome is up for grabs in google monopoly lawsuit final steps what now?
  # ladybird browser? not ready yet obv and apple swift wtf?
  # servo? dead? ladybird dev says rust not good for oop (dom) based browsers
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox.override {
    cfg.speechSynthesisSupport = false;
  };

  xdg.mimeApps =
    let
      ff = {
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "application/pdf" = [ "firefox.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
        "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
        "text/x-nfo" = [ "micro.desktop" ];
        "text/plain" = [ "micro.desktop" ];
        "x-scheme-handler/heroic" = [ "com.heroicgameslauncher.hgl.desktop" ];
        "application/x-tar" = [ "peazip-extract-here.desktop" ];
        "application/zip" = [ "peazip-extract-smart.desktop" ];
        "application/vnd.rar" = [ "peazip-extract-here.desktop" ];
        "image/jpeg" = [ "qimgv.desktop" ];
        "image/png" = [ "qimgv.desktop" ];
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

  password_mgr.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
