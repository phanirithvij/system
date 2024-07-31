{ config, ... }:
{
  sops.defaultSopsFile = ./secrets.yml;
  sops.defaultSopsFormat = "yaml";

  sops.age.sshKeyPaths = [ "/home/rithvij/.ssh/id_ed25519" ];
  #sops.age.keyFile = "/home/user/.config/sops/age.key";
}
