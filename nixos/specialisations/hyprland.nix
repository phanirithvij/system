{
  flake-inputs,
  lib,
  pkgs,
  system,
  ...
}:
{
  specialisation.hyprland = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:hyprland" ];
      programs.hyprland = {
        enable = true;
        package = flake-inputs.hyprland.packages.${system}.hyprland;
        portalPackage = flake-inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
      };
      programs.hyprlock.enable = true;
      services.desktopManager.plasma6.enable = lib.mkForce false;
      environment.systemPackages = [ pkgs.nwg-displays ];
    };
  };
}
