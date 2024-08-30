{ modulesPath, lib, ... }:
{
  specialisation.tty = {
    inheritParentConfig = true;
    configuration = {
      # The bug below with noXlibs occurs due to importing minimal profile
      # it fails to compile ghc-8.6
      imports = [ "${modulesPath}/profiles/minimal.nix" ];
      hardware.opentabletdriver.enable = lib.mkForce false;
      # https://github.com/NixOS/nixpkgs/issues/102137
      environment.noXlibs = lib.mkForce false;
      services = {
        xserver.enable = lib.mkForce false;
        displayManager.ly.enable = lib.mkForce false;
        desktopManager.plasma6.enable = lib.mkForce false;
        # TODO disable graphical profile
      };
    };
  };
}
