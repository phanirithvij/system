{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.tailscale ];
  services.tailscale = {
    # TODO later, make nixos modules/config/settings thing
    # so I can enable/disable them from ouside
    enable = false;
    useRoutingFeatures = "client";
    openFirewall = true;
    extraUpFlags = [ "--operator=phanirithvij@github" ];
    #extraUpFlags = [ "--login-server http://armyofrats.in" ];
  };
}
