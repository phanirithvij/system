{ mkLazyApp, pkgs, ... }:
mkLazyApp {
  pkg = pkgs.spotify;
  debugLogs = true;
}
