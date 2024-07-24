{
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
{
  specialisation.hyprland = {
    inheritParentConfig = true;
    configuration = {
      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${system}.hyprland;
        portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
      };
      programs.hyprlock.enable = true;
      services.desktopManager.plasma6.enable = lib.mkForce false;
      environment.systemPackages = [ pkgs.nwg-displays ];
    };
  };
}
