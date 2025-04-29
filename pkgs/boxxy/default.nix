{ pkgs, ... }:
{
  nixpkgs-track-boxxed = import ./nixpkgs-track.nix {
    inherit pkgs;
    inherit (pkgs) lib;
  };
}
