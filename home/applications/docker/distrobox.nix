{ pkgs, ... }:
let
  dtui = import ./distrobox-tui.nix { inherit (pkgs) lib buildGoModule fetchFromGitHub; };
in
{
  home.packages = [
    pkgs.distrobox
    dtui
  ];
}
