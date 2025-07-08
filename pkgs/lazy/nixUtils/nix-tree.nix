{ mkLazyApp, pkgs, ... }:
mkLazyApp {
  pkg = pkgs.nix-tree;
}
