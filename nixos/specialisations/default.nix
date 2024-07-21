{
  lib,
  pkgs,
  modulesPath,
  inputs,
  system,
  ...
}:
{
  # systemd-profiles idea I had can now be achieved
  # mainly a server profile (no audio, gui, etc)
  # and multiple modes to choose from in boot menu
  imports = [
    ./cosmic.nix
    ./hyprland.nix
    ./lemurs.nix
    ./ly.nix
    ./tty.nix
    ./tuigreet.nix
    ./xfce.nix
  ];

}
