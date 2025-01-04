{

  virtualisation.lxd.enable = true;

  # TODO move this
  users.users.rithvij = {
    extraGroups = [ "lxd" ];
  };

}
