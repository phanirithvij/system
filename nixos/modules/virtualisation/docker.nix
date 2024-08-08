{ pkgs, ... }:
{
  # https://nixos.wiki/wiki/Podman
  virtualisation = {
    # waydroid.enable = true;
    docker = {
      enable = true;
      enableOnBoot = true;
      package = pkgs.docker_25;
      daemon.settings = {
        dns = nameservers;
      };
    };
  };
  hardware.nvidia-container-toolkit.enable = true;
}
