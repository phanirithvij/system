{ pkgs, ... }:
{
  programs.jujutsu-aliases.enable = true;
  home.packages = [
    pkgs.jujutsu

    pkgs.jjui
    #pkgs.lazyjj # dropped from nurpkgs, forked to https://github.com/blazingjj/blazingjj
    #pkgs.jj-fzf # FIXME: broken
  ];
}
