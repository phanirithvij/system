{ flake-inputs, system }:
let
  schemaOverlay = import ./nix-schema.nix { inherit flake-inputs system; };
in
[
  schemaOverlay
]
