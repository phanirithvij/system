{ pkgs, ... }:
let
  onix = pkgs.writeShellApplication {
    name = "onix";
    text = builtins.readFile ../../../scripts/nixinternal/onix.sh;
  };
in
{
  home.packages = [ onix ];
}
