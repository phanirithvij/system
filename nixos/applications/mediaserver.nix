_: {
  services.jellyfin.enable = true;
  services.plex.enable = true;
  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/shed/music";
    };
  };
}
