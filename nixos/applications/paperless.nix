{ config, ... }:
{
  sops.secrets.paperless_passwd = { };
  services.paperless = {
    enable = true;
    settings = {
      PAPERLESS_ADMIN_USER = "admin";
    };
    passwordFile = config.sops.secrets.paperless_passwd.path;
    consumptionDirIsPublic = true;
  };
}
