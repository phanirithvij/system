{ pkgs, ... }:
let
  go-mtree = import ./go-mtree.nix { inherit (pkgs) lib buildGoModule fetchFromGitHub; };
in
{
  home.packages = [
    pkgs.gogup
    go-mtree
  ];
}
