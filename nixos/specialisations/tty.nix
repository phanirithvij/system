{
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  specialisation.tty = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:tty" ];
      # The bug below with noXlibs occurs due to importing minimal profile
      # it fails to compile ghc-8.6
      imports = [ "${modulesPath}/profiles/minimal.nix" ];
      hardware.opentabletdriver.enable = lib.mkForce false;
      # https://github.com/NixOS/nixpkgs/issues/102137
      # noXlibs has been deprecated forcefully, disable it
      # environment.noXlibs = lib.mkForce false;
      xdg.mime.enable = lib.mkForce false;
      xdg.icons.enable = lib.mkForce false;
      xdg.autostart.enable = lib.mkForce false;
      services = {
        xserver.enable = lib.mkForce false;
        displayManager.ly.enable = lib.mkForce false;
        # TODO disable graphical profile
      };
      desktopManagers.xfce.enable = lib.mkForce false;

      # From ngipkgs pretlax nixos test
      # Use kmscon <https://www.freedesktop.org/wiki/Software/kmscon/>
      # to provide a slightly nicer console, and while we're at it,
      # also use a nice font.
      # With kmscon, we can for example zoom in/out using [Ctrl] + [+]
      # and [Ctrl] + [-]
      services.kmscon = {
        enable = true;
        fonts = [
          {
            name = "Fira Code";
            package = pkgs.fira-code;
          }
        ];
      };
    };
  };
}
