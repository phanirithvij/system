{ mkLazyApp, pkgs, ... }:
mkLazyApp {
  pkg = pkgs.nurPkgs.unstablePkgs.subtitlecomposer;
  debugLogs = true;
}
