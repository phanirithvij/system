{ mkLazyApp, pkgs, ... }:
mkLazyApp {
  pkg = pkgs.nix-tree;
  debugLogs = true;
}
