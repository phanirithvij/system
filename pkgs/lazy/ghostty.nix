{ mkLazyApp, pkgs, ... }:
mkLazyApp {
  pkg = pkgs.nurPkgs.flakePkgs.ghostty;
}
