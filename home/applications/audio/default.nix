{ pkgs, ... }:
{
  home.packages = [ pkgs.lazyPkgs.qpwgraph ];
  #services.easyeffects.enable = true;
}
