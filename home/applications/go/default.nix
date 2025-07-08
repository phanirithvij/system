{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lazyPkgs.go
    gogup
    gomtree
  ];
}
