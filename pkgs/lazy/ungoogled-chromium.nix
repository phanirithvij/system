{ mkLazyApp, pkgs, ... }:
mkLazyApp {
  pkg = pkgs.ungoogled-chromium;
  binName = "chromium";
}
