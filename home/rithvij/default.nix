{
  config,
  pkgs,
  username,
  hostname,
  ...
}:
let
  homeDir = "/home/${username}";
  configDir = "${homeDir}/Projects/system"; # TODO impure??
in
{
  imports = [
    ../modules/appimgs.nix
    ../modules/android.nix
    ../modules/bookmarks
    ../modules/editors.nix

    ../modules/git
    ../modules/games

    ../modules/rss.nix
    ../modules/shells
    ../modules/tmux.nix
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
    dprint

    joplin # slow node tui app

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

    ffmpeg-headless
    sqlite-interactive
    miniserve
    filebrowser
    cargo-update
    sccache
    cargo-binstall
    pipx
    trash-cli

    # TODO remove this later when I know enough about python packages building with venv, poetry, devenv whatnot per project
    python3

    # TODO add this stuff
    #adb android-tools is too fat and heavy
    # rustdesk-server
    # gup # TODO write own overlay/package derivation
    # distrobox-tui # TODO own go package derivation
    # remote-touchpad
    # templ
    # rustup
    # mise
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
  programs.alacritty.enable = true;
  programs.aria2.enable = true;
  programs.bashmount.enable = true;
  programs.bat.enable = true;
  programs.bun.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.eza.enable = true;
  programs.fd.enable = true;
  programs.firefox.enable = true;
  programs.fzf.enable = true; # godsend
  programs.gallery-dl.enable = true;
  programs.jq.enable = true;

  programs.lf.enable = true; # godsend
  home.file.".config/lf".source = ./config/lf;

  programs.micro.enable = true;
  programs.mpv = {
    enable = true;
    config = {
      auto-window-resize = false;
    };
    scripts = with pkgs; [ mpvScripts.uosc ];
  };

  programs.poetry.enable = true;

  programs.wezterm.enable = true;
  home.file.".config/wezterm".source = ./config/wezterm;

  programs.ripgrep.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.topgrade = {
    enable = true;
    # https://github.com/topgrade-rs/topgrade/blob/1e9de5832d977f8f89596253f2880760533ec5f5/config.example.toml
    settings = {
      misc = {
        assume_yes = true;
        disable = [ "bun" ];
        set_title = false;
        cleanup = true;
        run_in_tmux = true;
        skip_notify = true;
      };
      linux = {
        nix_arguments = "--flake ${configDir}#${hostname}";
        home_manager_arguments = [
          "--flake"
          "${configDir}#${username}"
        ];
      };
    };
  };
  programs.yt-dlp.enable = true;
  programs.zoxide.enable = true;

  home.file.".cargo/config.toml".text = ''
    [registries.crates-io]
    protocol = "sparse"

    [build]
    rustc-wrapper = "sccache"
  '';

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
