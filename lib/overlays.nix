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
  # https://github.com/bluez/bluez/issues/821 fixed in 5.76
  # track https://github.com/NixOS/nixpkgs/pull/322127
  bluezOverlay = f: p: {
    bluez = p.bluez.overrideAttrs (old: rec {
      version = "5.76";
      src = p.fetchurl {
        url = "mirror://kernel/linux/bluetooth/bluez-${version}.tar.xz";
        hash = "sha256-VeLGRZCa2C2DPELOhewgQ04O8AcJQbHqtz+s3SQLvWM=";
      };
    });
  };
  atuinOverlay = f: p: {
    atuin = p.atuin.overrideAttrs (old: {
      buildFeatures = [ "client" ];
    });
  };
in
[
  schemaOverlay
  naviOverlay
  # bluezOverlay # TODO wait for official builds
  # atuinOverlay # TODO remove later once I get sync working?
]
