{ pkgs, lib, ... }:
let
  # pkg = pkgs.bashInteractive;
  pkg = pkgs.nixpkgs-track;
  mappings = [
    {
      target = "$HOME/.cache";
      rewrite = ''
        $SYSTEM_DIR/home/applications/pr-tracker/nixpkgs-track/''${TRACKGRP:-"$(\
          ${lib.getExe pkgs.fd} -d 1 -t d . \
           "$SYSTEM_DIR"/home/applications/pr-tracker/nixpkgs-track \
           | xargs -n1 ${lib.getExe' pkgs.coreutils "basename"} \
           | ${lib.getExe pkgs.fzf}\
        )"}'';
      mode = "directory";
    }
  ];
in
import ./lib.nix { inherit pkgs pkg mappings; }
