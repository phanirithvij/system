{ pkgs, ... }:
{
  services.jellyfin.enable = true;
  services.plex.enable = true;
  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/shed/music";
    };
  };
  # https://github.com/NixOS/nixpkgs/pull/323231/files#diff-ba3c88e433c973fef191fda9dc37b2310037eb0cb7dfade86e0861c4d854d6d7R13
  services.stash = {
    enable = false;
    dataDir = "/shed/stash";
    username = "stash";
    passwordFile = pkgs.writeText "stash-password" "stash";

    jwtSecretKeyFile = pkgs.writeText "jwt_secret_key" "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    sessionStoreKeyFile = pkgs.writeText "session_store_key" "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";

    plugins =
      let
        src = pkgs.fetchFromGitHub {
          owner = "stashapp";
          repo = "CommunityScripts";
          rev = "9b6fac4934c2fac2ef0859ea68ebee5111fc5be5";
          hash = "sha256-PO3J15vaA7SD4r/LyHlXjnpaeYAN9Q++O94bIWdz7OA=";
        };
      in
      [
        (pkgs.runCommand "stashNotes" { inherit src; } ''
          mkdir -p $out/plugins
          cp -r $src/plugins/stashNotes $out/plugins/stashNotes
        '')
        (pkgs.runCommand "Theme-Plex" { inherit src; } ''
          mkdir -p $out/plugins
          cp -r $src/themes/Theme-Plex $out/plugins/Theme-Plex
        '')
      ];
    mutableScrapers = true;
    scrapers =
      let
        src = pkgs.fetchFromGitHub {
          owner = "stashapp";
          repo = "CommunityScrapers";
          rev = "2ece82d17ddb0952c16842b0775274bcda598d81";
          hash = "sha256-AEmnvM8Nikhue9LNF9dkbleYgabCvjKHtzFpMse4otM=";
        };
      in
      [
        (pkgs.runCommand "FTV" { inherit src; } ''
          mkdir -p $out/scrapers/FTV
          cp -r $src/scrapers/FTV.yml $out/scrapers/FTV
        '')
      ];

    settings = {
      host = "localhost";
      port = 2459;
      stash = [ { path = "/srv"; } ];
    };
  };
}
