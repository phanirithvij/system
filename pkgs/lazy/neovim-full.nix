# TODO neovim full ide
{ lazy-app, pkgs, ... }:
lazy-app.override {
  pkg = pkgs.tesseract;
}
