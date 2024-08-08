{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.docker-opts.nameservers = lib.mkOption { type = lib.types.listOf lib.types.str; };
  config = {
    # https://nixos.wiki/wiki/Podman
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
    hardware.nvidia-container-toolkit.enable = true;
  };
}
