{
  config,
  lib,
  nixosModulesPath,
  ...
}:
{
  imports = map (path: nixosModulesPath + path) [
    "/services/system/swapspace.nix"
  ];
  config = {
    # https://github.com/numtide/system-manager/blob/main/nix/modules/upstream/nixpkgs/nginx.nix
    systemd.services.swapspace = lib.mkIf config.services.swapspace.enable {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };
  };
}
