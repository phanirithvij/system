{ lib, ... }:
{
  specialisation = {
    cosmic = {
      inheritParentConfig = true;
      configuration = {
        services.desktopManager.cosmic.enable = true;
        services.displayManager.cosmic-greeter.enable = true;
        services.desktopManager.plasma.enable = lib.mkForce false;
        services.displayManager.sddm.enable = lib.mkForce false;
      };
    };
  };
}
