{ pkgs, ... }:
{
  programs.lazy-apps.enable = true;
  home.packages = [
    pkgs.lazyPkgs.tesseract
    # pkgs.lazyPkgs.nixUtils.nix-tree
    #pkgs.lazyPkgs.nixUtils.nix-tree-flk
  ];
}
