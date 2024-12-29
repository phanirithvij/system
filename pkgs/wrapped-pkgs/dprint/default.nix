{ pkgs, ... }:
{
  wrappers.dprint = {
    basePackage = pkgs.dprint;
    appendFlags =
      [
        "--plugins"
      ]
      # TODO nix-update or something
      # curl -s https://plugins.dprint.dev/dprint/markdown/latest.json | jq -r '.url'
      # https://plugins.dprint.dev/info.json
      ++ builtins.map pkgs.fetchurl [
        {
          url = "https://plugins.dprint.dev/json-0.19.4.wasm";
          hash = "sha256-Sw+HkUb4K2wrLuQRZibr8gOCR3Rz36IeId4Vd4LijmY=";
        }
        {
          url = "https://plugins.dprint.dev/markdown-0.17.8.wasm";
          hash = "sha256-PIEN9UnYC8doJpdzS7M6QEHQNQtj7WwXAgvewPsTjqs=";
        }
        {
          url = "https://plugins.dprint.dev/toml-0.6.3.wasm";
          hash = "sha256-aDfo/sKfOeNpyfd/4N1LgL1bObTTnviYrA8T7M/1KNs=";
        }
        {
          url = "https://plugins.dprint.dev/g-plane/pretty_yaml-v0.5.0.wasm";
          hash = "sha256-6ua021G7ZW7Ciwy/OHXTA1Joj9PGEx3SZGtvaA//gzo=";
        }
      ];
  };
}
