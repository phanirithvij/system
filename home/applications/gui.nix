{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TODO fuzzel is wayland-ONLY so need to detect if wayland and enable
    # For bzmenu and as well as niri
    fuzzel
    rofi
    nurPkgs.flakePkgs.bzmenu
  ];
}
