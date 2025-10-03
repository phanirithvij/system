_: {
  specialisation.empty = {
    inheritParentConfig = false; # WARN
    configuration = {
      system.nixos.tags = [ "sp:empty" ];
      imports = [ ../../hosts/iron/hardware-configuration.nix ];
    };
  };
}
