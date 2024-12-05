{ pkgs, ... }:
let
  nixos-enter-custom = pkgs.writeShellApplication {
    name = "nixos-enter-custom";
    text = builtins.readFile ../../../scripts/nixos-enter-custom.sh;
  };
in
{
  environment.systemPackages = [ nixos-enter-custom ];
}
