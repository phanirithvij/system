{ pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./fish.nix
  ];

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
  };
  programs.eza.enable = true;
  programs.fd = {
    enable = true;
    package = pkgs.fd;
  };
  programs.fzf = {
    enable = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
  };
  programs.lf.enable = true;
  xdg.configFile."lf/lfrc".source = ../config/lf/lfrc;

  programs.zoxide.enable = true;
}
