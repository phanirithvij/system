# TODO jupyter notebooks setup using https://github.com/tweag/jupyenv
{ mkLazyApp, pkgs, ... }:
mkLazyApp {
  pkg = pkgs.tesseract;
}
