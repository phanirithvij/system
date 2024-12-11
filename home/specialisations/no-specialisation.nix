{ lib, ... }:
{
  imports = [
    (
      { config, ... }:
      lib.mkIf (config.specialisation != { }) {
        xdg.configFile."specialisations".text = ''
          xfce
          hyprland
        '';
      }
    )
  ];
}
