{ config, lib, ... }:
{
  options.desktopManagers.cinnamon.enable = lib.mkEnableOption "Enable cinnamon desktopManager";
  config = lib.mkIf config.desktopManagers.cinnamon.enable {
    services.xserver.desktopManager.cinnamon.enable = true;
    services.displayManager.ly.enable = lib.mkForce false;
    services.xserver.displayManager.gdm.enable = lib.mkForce true;
  };
}
