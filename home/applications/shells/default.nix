{ pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./fish.nix
  ];
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      style = "compact";
      inline_height = 24;
      invert = false;
    };
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
  programs.lf = {
    package = pkgs.wrappedPkgs.lf;
    enable = true;
  };
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
