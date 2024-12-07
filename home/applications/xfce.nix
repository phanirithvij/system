_: {
  imports = [ ./config/xfconf.nix ];

  # TODO
  # docklike plugin config
  #   - [ ] track with yadm?
  #         or home-manager with read/write to allow visual modification

  xdg.configFile."xfce4/panel/docklike-1.rc".text = ''
    [user]
    keyComboActive=true
    pinned=thunar;firefox;Alacritty;org.telegram.desktop;xfce4-appfinder;xfce4-settings-editor;
  '';
}
