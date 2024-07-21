{ lib, ... }:
{
  specialisation = {
    ly = {
      inheritParentConfig = true;
      configuration = {
        services = {
          displayManager.ly.enable = true;
          displayManager.ly.settings = {
            load = true;
            save = true;
          };
          displayManager.sddm.enable = lib.mkForce false;
          xserver.displayManager.lightdm.enable = lib.mkForce false;
        };
      };
    };
  };
}
