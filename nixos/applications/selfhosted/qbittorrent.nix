{ pkgs, ... }:
{
  services.flood.enable = true;

  # TODO qbittorrent-nox
  services.qbittorrent = {
    enable = true;
    package = pkgs.qbittorrent-nox;
    serverConfig.LegalNotice.Accepted = true;
    group = "users";
  };
}
