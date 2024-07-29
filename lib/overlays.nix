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
  # atuinOverlay # TODO remove later once I get sync working?
]
