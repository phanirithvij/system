{ lazy-app, pkgs, ... }:
lazy-app.override {
  pkg = pkgs.nix-tree;
}
