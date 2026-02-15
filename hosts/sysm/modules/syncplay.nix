{
  config,
  lib,
  nixosModulesPath,
  ...
}:
{
  imports = map (path: nixosModulesPath + path) [
    "/services/networking/syncplay.nix"
    "/services/networking/nftables.nix"
  ];
  config = {
    # https://github.com/numtide/system-manager/blob/main/nix/modules/upstream/nixpkgs/nginx.nix
    systemd.services.syncplay = lib.mkIf config.services.syncplay.enable {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };
  };
}
