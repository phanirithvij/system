{ pkgs, ... }:
{
  programs.jujutsu-aliases.enable = true;
  home.packages = [
    pkgs.jujutsu

    pkgs.jjui
    #pkgs.lazyjj #nur-pkgs unstable
    pkgs.jj-fzf
  ];
}
