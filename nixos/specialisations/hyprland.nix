{ lib, ... }:
{
  specialisation.hyprland = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:hyprland" ];
      desktopManagers.hyprland.enable = true;
      desktopManagers.xfce.enable = lib.mkForce false;
      nix.settings.substituters = [
        "https://hyprland.cachix.org"
      ];
      nix.settings.trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
