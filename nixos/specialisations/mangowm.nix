{ lib, ... }:
{
  specialisation.manngowm = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:mangowm" ];
      programs.mango.enable = true;
      services.displayManager.defaultSession = "mango"; # derived from mango.desktop filename
      desktopManagers.xfce.enable = lib.mkForce false;
      # TODO dunst into a module
      services.dunst.enable = true;
      services.dunst.settings = {
        global = {
          transparency = 10;
          frame_color = "#eceff1";
          font = "Droid Sans 9";
        };
        urgency_normal = {
          background = "#37474f";
          foreground = "#eceff1";
          timeout = 10;
        };
      };
    };
  };
}
