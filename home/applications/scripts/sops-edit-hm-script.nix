{ pkgs, ... }:
let
  sops-edit = pkgs.writeShellApplication {
    name = "sops-edit";
    runtimeInputs = [
      pkgs.ssh-to-age
      pkgs.sops
    ];
    text = builtins.readFile ../../../scripts/nixinternal/sops-edit.sh;
  };
in
{
  home.packages = [ sops-edit ];
}
