{ flake-inputs, system }:
let
  schemaOverlay = _: _: {
    nix-schema = flake-inputs.nix-schema.packages.${system}.nix.overrideAttrs (old: {
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
  naviOverlay = _: p: {
    navi = p.navi.overrideAttrs (old: rec {
      pname = "navi";
      version = "master";
      src = p.fetchFromGitHub {
        owner = "denisidoro";
        repo = "navi";
        rev = version;
        hash = "sha256-h7lF+jvrwjiMMmaqOGifJnBbTgjCK0WW2yocq7vO7zU=";
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
  pr-trackerOverlay = f: p: {
    pr-tracker = p.pr-tracker.overrideAttrs (old: {
      patches = [ ../pkgs/matt2432-pr-tracker-c9d0fd535b9ad1b53c212a87e0710d55d8b7f42e.patch ];
    });
  };
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
  # atuinOverlay # TODO remove later once I get sync working?
]
