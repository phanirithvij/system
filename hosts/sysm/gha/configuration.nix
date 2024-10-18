{ config, pkgs, ... }:
{
  imports = [
    ../modules/redis.nix
    ../modules/swapspace.nix
  ];
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";

    environment.systemPackages = with pkgs; [
      ripgrep
      fd
      hello
    ];

    services.swapspace.enable = true;

    services.redis = {
      package = pkgs.valkey;
      servers.redrum = {
        enable = true;
        port = 6379;
        user = "runner"; # TODO make it work with users.users.redis-redrum
      };
    };
  };
}
