{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.tailscale ];
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
    extraUpFlags = [ "--operator=phanirithvij@github" ];
    #extraUpFlags = [ "--login-server http://armyofrats.in" ];
  };
}
