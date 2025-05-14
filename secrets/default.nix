{ config, username, ... }:
let
  homeDir = if config ? home then config.home.homeDirectory else config.users.users.${username}.home;
in
{
  sops.defaultSopsFile = ./secrets.yml;
  sops.defaultSopsFormat = "yaml";

  sops.age.sshKeyPaths = [ "${homeDir}/.ssh/id_ed25519" ];
  #sops.age.keyFile = "/home/user/.config/sops/age.key";
}
