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
          hash = "sha256-b18FKOXz5mGKbIMd5TvmXz95KQ7fTT44Qzk46xGCQ/I=";
        })
        (createChromiumExtension {
          # dark reader
          version = "4.9.125";
          id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
          hash = "sha256-463iwFM5XippqdzU3J5c9asDc2XC6xbZlnLL2gCvilM=";
        })
        (createChromiumExtension {
          # search by image
          version = "8.5.2";
          id = "cnojnbdhbhnkbcieeekonklommdnndci";
          hash = "sha256-zp7xrEAQ544OZV98dP/aAxhsBQAsLKqfFAqzn9NRQSY=";
        })
        (createChromiumExtension {
          # refined github
          version = "26.5.13";
          id = "hlepfoohegkhhmjieoechaddaejaokhf";
          hash = "sha256-+JF3aJ86r2RoKD8bFYLDi0ONPlyiTH9JrYdJ5Z106Ao=";
        })
        (createChromiumExtension {
          # floccus bookmark sync
          version = "5.9.1";
          id = "fnaicdffflnofjppbagibeoednhnbjhg";
          hash = "sha256-tIJVy4GCWxY1uIHge4Z3f511MTNhRMZTYToXf/u9yTg=";
        })
        (createChromiumExtension {
          # kagi search
          version = "1.2.2.5";
          id = "cdglnehniifkbagbbombnjghhcihifij";
          hash = "sha256-weiUUUiZeeIlz/k/d9VDSKNwcQtmAahwSIHt7Frwh7E=";
        })
      ];
  };
}
