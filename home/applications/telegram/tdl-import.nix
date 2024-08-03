{ pkgs, ... }:
let
  tdl = import ./tdl.nix { inherit (pkgs) lib buildGoModule fetchFromGitHub; };
in
{
  home.packages = [ tdl ];
}
