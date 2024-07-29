{ pkgs, ... }:
{
  imports = [ ./distrobox.nix ];
  # TODO docker tools
  home.packages = with pkgs; [
    lazydocker
    docker-compose
  ];
}
