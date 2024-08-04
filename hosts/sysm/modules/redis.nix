{
  config,
  lib,
  nixosModulesPath,
  ...
}:
let
  redisName = name: "redis" + lib.optionalString (name != "") ("-" + name);
  enabledServers = lib.filterAttrs (_: conf: conf.enable) config.services.redis.servers;
in
{
  imports = map (path: nixosModulesPath + path) [
    "/services/databases/redis.nix"
    "/services/networking/firewall.nix"
    "/services/networking/nftables.nix"
  ];
  config = {
    systemd.services = lib.mapAttrs' (
      _: _: lib.nameValuePair (redisName name) { wantedBy = lib.mkForce [ "system-manager.target" ]; }
    ) enabledServers;
  };
}
