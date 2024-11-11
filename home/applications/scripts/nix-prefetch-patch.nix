{ pkgs, ... }:
{
  home.packages = [
    # https://matrix.to/#/!kjdutkOsheZdjqYmqp:nixos.org/$sYCNCRqaN1lmpkhHbaqUSW15tIvGSrOWDNCe66GgBq4
    (pkgs.writeShellScriptBin "nix-prefetch-patch" (
      builtins.readFile ../../../scripts/nix-prefetch-patch
    ))
  ];
}
