_: {

  imports = [
    ./bash.nix
    ./fish.nix
  ];

  programs.eza.enable = true;
  programs.fd.enable = true;
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
  };
  programs.lf.enable = true;
  home.file.".config/lf".source = ../config/lf;

}
