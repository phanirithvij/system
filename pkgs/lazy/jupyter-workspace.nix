# TODO jupyter notebooks setup using https://github.com/tweag/jupyenv
{ lazy-app, pkgs, ... }:
lazy-app.override {
  pkg = pkgs.tesseract;
}
