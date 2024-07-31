{ pkgs, ... }:
{
  # TODO
  # attic
  # harmonia
  # nix-serve-ng
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    port = 5000;
    openFirewall = false; # hosted in tailnet so firewall needs tailnet to be trusted
    secretKeyFile = "${./iron-priv.key}";
  };
}
