{ pkgs, ... }:
{
  services.vnstat.enable = true;
  # TODO move elsewhere
  services.atd.enable = true;
  environment.systemPackages = with pkgs; [ at ];

  services.cron.enable = true;
}
