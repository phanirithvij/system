{ mkLazyApp, pkgs, ... }:
mkLazyApp {
  pkg = pkgs.nurPkgs.all.gitbatch;
}
