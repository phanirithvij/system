{
  pkgs,
  config,
  sops,
  ...
}:
let
  ntfy-port = 5858;
  freshrss-port = 5959;
in
{
  services.ntfy-sh = {
    enable = true;
    settings = rec {
      listen-http = ":${toString ntfy-port}";
      base-url = "http://iron${listen-http}";
    };
  };

  sops.secrets.freshrss_password = {
    owner = config.users.users.freshrss.name;
  };
  services.freshrss = {
    enable = true;
    extensions = with pkgs.freshrss-extensions; [
      youtube
      reading-time
      title-wrap
    ];
    passwordFile = config.sops.secrets.freshrss_password.path;
    baseUrl = "http://iron:${toString freshrss-port}";
  };
  services.nginx.virtualHosts.${config.services.freshrss.virtualHost}.listen = [
    {
      addr = "iron";
      port = freshrss-port;
    }
  ];
}
