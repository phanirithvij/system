{
  virtualisation.lxd.enable = true;

  # TODO get the username from somewhere (nixos options)
  users.users.rithvij.extraGroups = [ "lxd" ];
}
