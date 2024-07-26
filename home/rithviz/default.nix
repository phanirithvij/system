{ config, pkgs, ... }:

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
    ../modules/bookmarks
    ../modules/editors.nix
    ../modules/git
    ../modules/media
    ../modules/shells
    ../modules/tmux.nix
    ../modules/topgrade.nix
    ../modules/tui.nix
  ];

  home.packages = with pkgs; [
    air # reload go run
    babelfish # bash to fish
    bat # fancy cat
    bashmount # very useful
    btop # fancy process manager like htop
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
    lf # file manager tui
    newsboat # rss
    fastfetch # sysinfo summary
    neovim # editor but slow (for some weird reason)
    nms # esoteric sneakers movie terminal effect
    macchina # neofetch alternative
    onefetch # neofetch like tool for git repos
    p7zip # 7z cli
    pulumi # TODO testdrive
    pv # progress vizualized
    qbittorrent
    qcomicbook
    qimgv # img viewer
    qrcp # fileserver with added qr ease of use
    rclone
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
    wtf # fancy dashboard tui
    xplr # TODO something temp, remove later
    yq # yaml cli
    yadm # dotfile manager
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  programs.zoxide.enable = true;
}
