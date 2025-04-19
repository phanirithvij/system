_: {
  # systemd-profiles idea I had can now be achieved
  # mainly a server profile (no audio, gui, etc)
  # and multiple modes to choose from in boot menu

  imports = [
    #./cinnamon.nix
    #./hyprland.nix
    ./niri.nix
    ./tty.nix
    #./tuigreet.nix
    #./xfce
    #./plasma.nix

    # NOTE specialisations cannot have '-' (OWN restriction, see the implementation in the below file)
    ../applications/scripts/home-manager-switch-specialisation.nix
  ];
}
