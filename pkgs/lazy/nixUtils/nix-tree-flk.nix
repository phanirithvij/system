{ mkLazyApp, pkgs, ... }:
mkLazyApp {
  pkg = pkgs.nurPkgs.flakePkgs.nix-tree;
  debugLogs = true;
}
