{ pkgs, ... }:
let
  gh-pr-chk-shlw = pkgs.writeShellApplication {
    name = "gh-pr-chk-shlw";
    text = builtins.readFile ../../../scripts/nixinternal/gh-pr-checkout-shallow.sh;
  };
in
{
  environment.systemPackages = [ gh-pr-chk-shlw ];
}
