{ lib, ... }:
{
  specialisation = {
    lemurs = {
      inheritParentConfig = true;
      configuration = {
        services = {
          displayManager.sddm.enable = lib.mkForce false;
          xserver.displayManager.lightdm.enable = lib.mkForce false;
          xserver.enable = true;
          displayManager.enable = true;
          lemurs = {
            enable = true;
            x11.enable = true;
            wayland.enable = true;
          };
          desktopManager.plasma6.enable = true;
        };
      };
    };

  };
}
