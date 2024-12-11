_: {
  specialisation.xfce = {
    configuration = {
      imports = [ ../applications/config/xfconf.nix ];
      xdg.configFile."specialisation".text = "xfce";
    };
  };
  specialisation.hyprland = {
    configuration = {
      # TODO hyprland
      xdg.configFile."specialisation".text = "hyprland";
    };
  };
}
