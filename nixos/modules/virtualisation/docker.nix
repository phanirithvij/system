{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.docker-opts.nameservers = lib.mkOption { type = lib.types.listOf lib.types.str; };
  config = {
    # https://wiki.nixos.org/wiki/Podman
    virtualisation = {
      # waydroid.enable = true;
      docker = {
        enable = true;
        enableOnBoot = true;
        package = pkgs.docker_25;
        daemon.settings = {
          dns = config.docker-opts.nameservers;
        };
      };
    };
    users.users.rithvij.extraGroups = [ "docker" ];
    # broke xserver for me, had to git bisect
    # see https://github.com/NixOS/nixpkgs/pull/344174
    # hardware.nvidia-container-toolkit.enable = true;
  };
}
