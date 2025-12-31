{ pkgs, ... }:
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "dolphie" ];
    ensureUsers = [
      {
        name = "dolphie";
        ensurePermissions = {
          "dolphie.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
}
