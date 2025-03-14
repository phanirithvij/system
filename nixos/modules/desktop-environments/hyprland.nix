{
  config,
  flake-inputs,
  lib,
  pkgs,
  system,
  ...
}:
{
  options.desktopManagers.hyprland.enable = lib.mkEnableOption "Enable hyprland desktopManager";
  config = lib.mkIf config.desktopManagers.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = flake-inputs.hyprland.packages.${system}.hyprland;
      portalPackage = flake-inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    };
    programs.hyprlock.enable = true;
    environment.systemPackages = [ pkgs.nwg-displays ];
  };
}
