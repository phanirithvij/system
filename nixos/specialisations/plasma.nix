_: {
  # TODO get config from somewhere else
  # so that it allows me to toggle a specialisation on off
  # also keep it in the original config
  # eg.
  #    plasma boolean on/off in main config
  #    and a specialisation which turns it on
  #    and I can toggle plasma specialisation
  specialisation.plasma = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:plasma" ];
      services.desktopManager.plasma6.enable = true;
    };
  };
}
