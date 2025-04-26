{ lib, ... }:
{
  specialisation.xfce = {
    configuration = {
      imports = [ ./xfce.nix ];
      xdg.configFile."specialisation".text = "xfce";
    };
  };
  specialisation.hyprland = {
    configuration = {
      # TODO hyprland
      xdg.configFile."specialisation".text = "hyprland";
      services.espanso = {
        x11Support = lib.mkForce false;
        waylandSupport = lib.mkForce true;
      };
    };
  };
  specialisation.niri = {
    configuration = {
      # TODO niri
      xdg.configFile."specialisation".text = "niri";
      services.espanso = {
        x11Support = lib.mkForce false;
        waylandSupport = lib.mkForce true;
      };
    };
  };
  specialisation.plasma = {
    configuration = {
      # TODO plasma
      xdg.configFile."specialisation".text = "plasma";
      # espanso is fat by default, see home/applications/bookmarks/espanso.nix
    };
  };
}
