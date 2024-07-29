{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";

    environment.systemPackages = with pkgs; [
      ripgrep
      fd
      hello
    ];
  };
}
