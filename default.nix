/*
  TODO goals
   - flake-inputs will give orders of magnitude times flake-inputs prefetch
   - default.nix first, flake.nix supported if more purity required
*/
let
  flake-inputs = import (fetchTarball {
    url = "https://github.com/phanirithvij/flake-inputs/tarball/file-type"; # TODO tag
    sha256 = "sha256-4d2u5m8TOQMSt1uKlQiJ3zZgykQ+FiXn8VtyYaiAQfM=";
  });
  inherit (flake-inputs) import-flake;
in
{
  flake ? import-flake { src = ./.; },
  sources ? flake.inputs,
  nixpkgs ? sources.nixpkgs,
  overlays ? [ ],
  config ? { }, # allows --arg config from cli
  system ? builtins.currentSystem,
  pkgs ? import nixpkgs {
    inherit
      config
      overlays
      system
      ;
  },
}:
let
  self = sources;
in
self
