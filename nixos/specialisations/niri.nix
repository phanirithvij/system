{
  lib,
  pkgs,
  ...
}:
{
  specialisation.niri = {
    inheritParentConfig = true;
    configuration = {
      imports = [ ];
      system.nixos.tags = [ "sp:niri" ];
      programs.niri.enable = true;
      programs.niri.package = pkgs.niri-unstable;
      # TODO overlays conditionally?
      # nixpkgs.overlays = [ flake-inputs.niri.overlays.niri ];
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
