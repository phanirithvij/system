{ pkgs, ... }:
{
  services.jackett.enable = true;
  services.jackett.package = pkgs.jackett.overrideAttrs {
    doCheck = false; # temp failure TBD nixpkgs issue
  };
}
