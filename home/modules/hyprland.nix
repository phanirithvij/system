{ pkgs, ... }:
{
  home.file.".config/hypr".source = ./config/hypr;
  home.packages = [
    pkgs.wl-clipboard-rs
    pkgs.cliphist
  ];
}
