{ lazy-app, pkgs, ... }:
lazy-app.override {
  pkg = pkgs.spotify;
  debugLogs = true;
}
