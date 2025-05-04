{ pkgs, lib, ... }:
let
  script = pkgs.writeShellScriptBin "wtrak" ''
    env TRACKGRP="$(\
      ${lib.getExe pkgs.fd} -d 1 -t d . \
        $SYSTEM_DIR/home/applications/pr-tracker/nixpkgs-track \
        | xargs -n1 ${lib.getExe' pkgs.coreutils "basename"} \
        | ${lib.getExe pkgs.fzf}\
    )" \
      viddy --disable_auto_save -p -n 30 \
        ${lib.getExe pkgs.wrappedPkgs.nixpkgs-track} check
  '';
in
{
  home.packages = [
    # pkgs.wrappedPkgs.nixpkgs-track
    pkgs.boxxyPkgs.boxxed-nixpkgs-track
    script
  ];
}
