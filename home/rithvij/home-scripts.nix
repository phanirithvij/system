{ config, pkgs, ... }:
let
  scriptPrTracker = pkgs.callPackage ../../pkgs/pr-tracker-userscript.nix { inherit config; };
in
{
  sops.secrets.gh_t_pr_tracker = { };
  home.packages = [ scriptPrTracker ];
}
