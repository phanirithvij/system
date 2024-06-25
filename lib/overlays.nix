{ inputs, system }:
let
  schemaOverlay = f: p: {
    nix-schema = inputs.nix-schema.packages.${system}.nix.overrideAttrs (old: {
      doCheck = false;
      doInstallCheck = false;
      postInstall =
        old.postInstall
        + ''
          rm $out/bin/nix-*
          mv $out/bin/nix $out/bin/nix-schema
        '';
    });
  };
  naviOverlay = f: p: {
    navi = p.navi.overrideAttrs (old: rec {
      pname = "navi";
      version = "master";
      src = p.fetchFromGitHub {
        owner = "denisidoro";
        repo = "navi";
        hash = "sha256-8e2sbKc6eYDerf/q0JwS6GPXkqDXLerbPqWK6oemSqM=";
      };
      cargoDeps = old.cargoDeps.overrideAttrs (
        p.lib.const {
          name = "${pname}-vendor.tar.gz";
          inherit src;
          outputHash = "sha256-vNfcSHNP0KNM884DMtraYohLOvumSZnEtemJ+bJSQ5o=";
        }
      );
    });
  };
in
[
  schemaOverlay
  naviOverlay
]
