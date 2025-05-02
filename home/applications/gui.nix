{ pkgs, flake-inputs, ... }:
{
  home.packages = [
    # TODO fuzzel is wayland-ONLY so need to detect if wayland and enable
    # For bzmenu and as well as niri
    pkgs.fuzzel
    pkgs.rofi
    flake-inputs.bzmenu.packages.${pkgs.system}.default
  ];
}
