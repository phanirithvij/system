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
  programs.bat.enable = true;
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
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };
  programs.zoxide.enable = true;
}
