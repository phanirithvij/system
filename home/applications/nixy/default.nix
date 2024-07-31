{ pkgs, ... }:
let
  pr-tracker = import ../../../pkgs/pr-tracker.nix {
    inherit (pkgs)
      rustPlatform
      lib
      fetchzip
      openssl
      pkg-config
      systemd
      ;
  };
in
{
  imports = [ ./nix.nix ];
  home.packages = [ pr-tracker ];
}
