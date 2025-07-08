{ pkgs, ... }:
{
  services.cloudflare-warp.enable = true;
  services.cloudflare-warp.package = pkgs.lazyPkgs.cloudflare-warp;
}
