{ pkgs, ... }:

# TODO generalise this, test this in a vm
# this host is dead, deleted

# rust
# delta exa bat fd ripgrep sd starship du-dust

# go
# fzf lazygit hub gdu lf ...

# old config missed: tmate

{
  home.username = "rithviz";
  home.homeDirectory = "/home/rithviz";
  news.display = "silent";

  imports = [
    ../../applications/bookmarks
    ../../applications/bashmount.nix
    ../../applications/editors
    ../../applications/git
    ../../applications/media
    ../../applications/shells
    ../../applications/tmux.nix
    ../../applications/topgrade.nix
    ../../applications/tui.nix

    ./home-scripts.nix
    ../../../secrets

    ../../specialisations
  ];

  home.packages = with pkgs; [
    air # reload go run
    babelfish # bash to fish
    cmatrix # screensaver
    difftastic # fancy diff
    duf # fancy du
    eget # download binaries from github releases
    eza # fancy ls
    exercism # TODO remove, some progamming exercises or shit
    gdu # disk usage analyzer tui
    git-filter-repo # git history rewrite
    go-task # TODO ?
    gopass # passwords and secrets manager
    gopass-hibp # plugin for gopass
    htop # process monitor
    hugo # static site generator
    jid # jq query repl
    jq # json cli
    lazydocker # docker tui
    newsboat # rss
    nms # esoteric sneakers movie terminal effect
    fastfetch # sysinfo summary
    macchina # neofetch alternative
    onefetch # neofetch like tool for git repos
    microfetch # notashelf/microfetch
    p7zip # 7z cli
    pv # progress vizualized
    qbittorrent
    qcomicbook
    qimgv # img viewer
    qrcp # fileserver with added qr ease of use
    remote-touchpad # control screen via webui from different device
    ripgrep # modern grep cli
    rnote # note taking
    rustup # cargo, rust
    #rtx # package version manager for linux asdf rust clone (now installing via cargo as nix version is behind)
    screenfetch # neofetch alternative
    starship # prompt custom
    sysz # systemctl tui
    timeshift # system restore points
    unar # rar format
    ulauncher # TODO remove after checking if useful alts rofi, dmenu, voidlinux-youtuber-dotfiles, espanso
    viddy # watch alternative
    wtfutil # fancy dashboard tui
    xplr # TODO something temp, remove later
    yq # yaml cli
    yadm # dotfile manager
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
  programs.firefox.enable = true;
}
