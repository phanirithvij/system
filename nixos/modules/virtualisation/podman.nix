{ pkgs, ... }:
{
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = false; # for now, I have docker installed as well
    defaultNetwork.settings.dns_enabled = true;
  };
  # TODO Dentritic over home-manager pkgs
  users.users.rithvij.packages = [ pkgs.lazyPkgs.podman-tui ];
  users.users.rithvij.extraGroups = [ "podman" ];
  users.users.rithvij.isNormalUser = true;
}
