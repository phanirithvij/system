_: {
  # NOTES
  # restart xfce or xfwm4 after config change
  # https://forum.xfce.org/viewtopic.php?id=7878 - didn't work, loginctl and relogin
  xfconf.settings = {
    xfce4-keyboard-shortcuts = {
      # <Primary> is ctrl https://unix.stackexchange.com/questions/168505/what-key-is-primary
      "commands/custom/<Primary>Escape" = "xfce4-popup-whiskermenu";
      "commands/custom/<Super>" = "xfce4-popup-whiskermenu";
      "xfwm4/custom/<Super>Up" = "maximize_window_key";
      "xfwm4/custom/<Super>Down" = "hide_window_key";
      "xfwm4/custom/<Super>d" = "show_desktop_key";
      # makes espanso keybind work
      "xfwm4/custom/<Alt>space" = "";
    };
    # TODO panel plugins etc.
    # https://forum.xfce.org/viewtopic.php?id=17478
    pointers = {
      # https://docs.xfce.org/xfce/xfce4-settings/4.12/mouse
      #
      "DELL07EA00_06CB7E92_Mouse/ReverseScrolling" = true;
    };
  };
}
