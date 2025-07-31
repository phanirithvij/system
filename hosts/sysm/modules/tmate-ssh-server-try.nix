{
  config,
  lib,
  nixosModulesPath,
  ...
}:
{
  disabledModules = [ "upstream/nixpkgs" ];
  imports = map (path: nixosModulesPath + path) [
    "/misc/meta.nix"
    "/services/networking/tmate-ssh-server.nix"
    "/tasks/network-interfaces.nix"
    "/services/networking/mstpd.nix"
    "/services/hardware/udev.nix"
    "/system/boot/modprobe.nix"
    "/system/boot/systemd/initrd.nix"
    "/system/boot/stage-1.nix"
    "/virtualisation/nixos-containers.nix"
    "/system/boot/kernel.nix"
    "/config/sysctl.nix"
    "/tasks/swraid.nix"
    "/misc/lib.nix"
    #"/system/boot/stage-2.nix"
    #"/system/boot/loader/loader.nix"
  ];
  config = {
    # https://github.com/numtide/system-manager/blob/main/nix/modules/upstream/nixpkgs/nginx.nix
    systemd.services.tmate-ssh-server = lib.mkIf config.services.tmate-ssh-server.enable {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };
  };
}
