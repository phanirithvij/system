{ pkgs, ... }:
{
  home.packages = [
    pkgs.lazyPkgs.tesseract
    # pkgs.lazyPkgs.nixUtils.nix-tree
    pkgs.lazyPkgs.nixUtils.nix-tree-flk
  ];
}
