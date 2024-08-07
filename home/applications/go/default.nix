{ pkgs, ... }:
let
  gomtree = import ./gomtree.nix { inherit (pkgs) lib buildGoModule fetchFromGitHub; };
in
{
  home.packages = [
    pkgs.gogup
    gomtree
  ];
}
