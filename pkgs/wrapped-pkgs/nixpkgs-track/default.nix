{ pkgs, ... }:
# Custom wrapper around nixpkgs-track to allow separate dashboards
{
  wrappers.nixpkgs-track = {
    basePackage = pkgs.nixpkgs-track;
    pathAdd = [
      pkgs.gh
    ];
    extraWrapperFlags = ''
      --run 'export GITHUB_TOKEN=''${GITHUB_TOKEN-"$(gh auth token)"}' \
      --run 'export XDG_CACHE_HOME=$SYSTEM_DIR/home/applications/pr-tracker/nixpkgs-track/$TRACKGRP'
    '';
  };
}
