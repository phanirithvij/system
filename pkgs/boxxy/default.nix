{ pkgs, ... }:
{
  boxxed-nixpkgs-track = import ./nixpkgs-track.nix {
    inherit pkgs;
    inherit (pkgs) lib;
  };
}
