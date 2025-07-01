{
  pkgs,
  flake-inputs,
  system,
  ...
}:
{
  # https://discourse.nixos.org/t/use-a-module-from-nixpkgs-unstable-in-flake/31463/9
  imports =
    let
      inherit (flake-inputs) nixpkgs-qb;
      qbpkgs = nixpkgs-qb.legacyPackages.${system};
      inherit (qbpkgs) qbittorrent-nox;
    in
    [
      # Override netdata from nixpkgs-unstable
      {
        # disabledModules = [ "services/torrent/qbittorrent.nix" ]; # not needed as it isn't there in nixpkgs
        nixpkgs.overlays = [ (_: _: { inherit qbittorrent-nox; }) ];
      }
      (nixpkgs-qb + /nixos/modules/services/torrent/qbittorrent.nix)
    ];

  # TODO qbittorrent-nox
  services.qbittorrent = {
    enable = true;
    package = pkgs.qbittorrent-nox; # overlay
    serverConfig.LegalNotice.Accepted = true;
    group = "users";
  };

  services.flood.enable = true;
}
