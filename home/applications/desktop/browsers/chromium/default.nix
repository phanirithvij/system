# https://github.com/nix-community/home-manager/issues/2216#issuecomment-2653060202
{
  lib,
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    # TODO lazy brave, unfree chrome, edge etc.
    # wait for servo and ladybird and maybe one day google will die
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.lazyPkgs.ungoogled-chromium;
    extensions =
      let
        createChromiumExtensionFor =
          browserVersion:
          {
            id,
            hash,
            version,
          }:
          {
            inherit id;
            crxPath = pkgs.fetchurl {
              url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
              name = "${id}.crx";
              inherit hash;
            };
            inherit version;
          };
        createChromiumExtension = createChromiumExtensionFor (
          lib.versions.major pkgs.lazyPkgs.ungoogled-chromium.version
        );
      in
      [
        (createChromiumExtension {
          # ublock origin
          version = "1.71.0";
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          hash = "sha256-VJ1fsew67rnYSg2Z8pqUlMtqYKjNA8Lmk6s5vqMyPBw=";
        })
        (createChromiumExtension {
          # dark reader
          version = "4.9.125";
          id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
          hash = "sha256-jAhpgyVucHif6fJ2VUJoOtPAcHUh7BdAEMr9JpdocBY=";
        })
        (createChromiumExtension {
          # search by image
          version = "8.5.2";
          id = "cnojnbdhbhnkbcieeekonklommdnndci";
          hash = "sha256-tXmra22r8lM9WE/F2dM9gvLqG6xeUg4Q9PrwizJSKKs=";
        })
        (createChromiumExtension {
          # refined github
          version = "26.5.13";
          id = "hlepfoohegkhhmjieoechaddaejaokhf";
          hash = "sha256-+dKFa5tx4cRft/q4pPldUznWgamojMjXb2xRfAN3kFU=";
        })
      ];
  };
}
