{
  config,
  lib,
  nixosModulesPath,
  ...
}:
{
  imports = map (path: nixosModulesPath + path) [
    "/services/networking/cloudflared.nix"
    "/misc/meta.nix"
  ];
  config = {
    systemd.services = lib.mapAttrs' (
      name: _:
      lib.nameValuePair "cloudflared-tunnel-${name}" {
        wantedBy = lib.mkForce [ "system-manager.target" ];
      }
    ) config.services.cloudflared.tunnels;
  };
}
