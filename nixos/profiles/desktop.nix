_: {
  # TODO qimgv style zoom viewer mode for comic reading (1, 2, 3, scrolling the image with touchpad)
  # - full page images
  # - remote touch taps if screen is not a touchscreen
  #   - feels like a better remote-touchpad
  # - zooming gestures with multiple fingers
  # - easy switch to manga mode
  # - continous scroll etc.
  # TODO add hotkeys to yacreader all menu entires
  # TODO make it work with other comic readers, sumatrapdf etc.
  # TODO autorotate with/without sensors on laptop (undg/autorotate)
  # TODO Lazy Apps + nixpkgs multiverse - avoid IFD, avoid custom substituter, use a single github repo with lfs as source for desktop files and icons. See sumatrapdf deskop file generation.
  imports = [
    ../applications/games.nix
    ../applications/books/sumatrapdf.nix
  ];
}
