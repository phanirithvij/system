{ lib, ... }:
{
  specialisation.niri = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:niri" ];
      desktopManagers.niri.enable = true;
      desktopManagers.xfce.enable = lib.mkForce false;
      # TODO I guess the below is fairly useless
      # given that enabling niri profile/specialisation will not immediately give nix access to these
      nix.settings.substituters = [
        "https://niri.cachix.org"
      ];
      nix.settings.trusted-public-keys = [
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
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
