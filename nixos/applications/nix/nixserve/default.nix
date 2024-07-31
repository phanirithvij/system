{ config, pkgs, ... }:
{
  # TODO
  # attic
  # harmonia
  # nix-serve-ng
  sops.secrets.nix-serve-privkey = { };
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    port = 5000;
    openFirewall = false; # hosted in tailnet so firewall needs tailnet to be trusted
    secretKeyFile = config.sops.secrets.nix-serve-privkey.path;
  };
}
