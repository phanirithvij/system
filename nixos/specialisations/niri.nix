{
  lib,
  pkgs,
  ...
}:
{
  specialisation.niri = {
    inheritParentConfig = true;
    configuration = {
      programs.niri.enable = true;
      # TODO overlays conditionally?
      # nixpkgs.overlays = [ flake-inputs.niri.overlays.niri ];
      programs.niri.package = pkgs.niri-unstable;
      environment.variables.NIXOS_OZONE_WL = "1";
      environment.systemPackages = with pkgs; [
        wl-clipboard-rs
        wayland-utils
        libsecret
        cage
        gamescope
        xwayland-satellite-unstable
        swaybg
        nwg-displays # ?
      ];
      services.desktopManager.plasma6.enable = lib.mkForce false;
    };
  };
}
