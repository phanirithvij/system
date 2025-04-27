{ hostname, ... }:
let
  hostvars = import ../../hosts/${hostname}/variables.nix;
in
{
  services.jellyfin.enable = true;
  services.plex.enable = true;
  services.navidrome = {
    enable = true;
    settings = {
      inherit (hostvars) MusicFolder;
    };
  };
}
