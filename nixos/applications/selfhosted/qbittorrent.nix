{ pkgs, ... }:
{
  # TODO qbittorrent-nox and qbittorrent sharing same db
  services.qbittorrent = {
    enable = false;
    package = pkgs.qbittorrent-nox;
    serverConfig.LegalNotice.Accepted = true;
    group = "users";
  };

  #services.flood.enable = true;
}
