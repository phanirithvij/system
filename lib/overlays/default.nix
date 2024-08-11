{ flake-inputs, system }:
let
  schemaOverlay = import ./nix-schema.nix { inherit flake-inputs system; };
  naviOverlay = import ./navi-master.nix;
  pr-trackerOverlay = import ./pr-tracker-overlay.nix;
  git-bugOverlay = import ./git-bug-master.nix;
in
/*
  atuinOverlay = f: p: {
    atuin = p.atuin.overrideAttrs (old: {
      buildFeatures = [ "client" ];
    });
  };
*/
[
  schemaOverlay
  naviOverlay
  pr-trackerOverlay
  git-bugOverlay
  # atuinOverlay # TODO remove later once I get sync working?
]
