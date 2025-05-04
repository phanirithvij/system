{ pkgs, ... }:
{
  home.packages = [ pkgs.lazyPkgs.tesseract ];
}
