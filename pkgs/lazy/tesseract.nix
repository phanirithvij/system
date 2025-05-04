{ lazy-app, pkgs, ... }:
lazy-app.override {
  pkg = pkgs.tesseract;
}
