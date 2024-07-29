{
  config,
  lib,
  nixosModulesPath,
  ...
}:
{
  imports = map (path: nixosModulesPath + path) [
    "/services/databases/redis.nix"
    "/services/networking/firewall.nix"
    "/services/networking/nftables.nix"
  ];
  config = {
    # https://github.com/numtide/system-manager/blob/main/nix/modules/upstream/nixpkgs/nginx.nix
    systemd.services.redis-redrum = lib.mkIf config.services.redis.servers.redrum.enable {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };
  };
}
