{
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = false; # for now, I have docker installed as well
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users.rithvij = {
    isNormalUser = true;
    extraGroups = [ "podman" ];
  };
}
