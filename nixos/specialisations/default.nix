_: {
  # systemd-profiles idea I had can now be achieved
  # mainly a server profile (no audio, gui, etc)
  # and multiple modes to choose from in boot menu

  imports = [
    #./xfce # now the default config
    ./empty.nix
    ./tty.nix
    #./plasma.nix
    #./niri.nix
    #./hyprland.nix
    #./cinnamon.nix
    #./deepin.nix # for nostalgia, removed from nixpkgs at some point
    #./tuigreet.nix
    #./bspwm.nix #tried it kinda, sxhkd is nice but can't bother with bars, hjkl, maybe when I learn vim keybinds

    # NOTE specialisations cannot have '-' (OWN restriction, see the implementation in the below file)
    # TODO relocate to hm config with systemd oneshot
    # ../applications/scripts/home-manager-switch-specialisation.nix
  ];
}
