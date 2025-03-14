{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktopManagers.niri.enable = lib.mkEnableOption "Enable niri desktopManager";
  config = lib.mkIf config.desktopManagers.niri.enable {
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
  };
}
