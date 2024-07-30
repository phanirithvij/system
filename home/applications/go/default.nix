{ pkgs, ... }:
let
  gup = import ./gup.nix { inherit (pkgs) lib buildGoModule fetchFromGitHub; };
in
{
  home.packages = [ gup ];
}
