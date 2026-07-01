{
  lib,
  pkgs,
  ...
}:
{
  services.pixelfed = {
    enable = true;
    domain = "iron.tail4aa8d.ts.net";
    nginx.listen = [
      {
        port = 9393;
        addr = "127.0.0.1";
      }
    ];
    # not a real secret
    secretFile = pkgs.writeText "dont-do-it-like-this" ''
      APP_KEY="base64:x/cMhKq1nL8e2V0rA5zP4vG7tB9wD2xF5yH8sJ1kMNo="
    '';
    settings = {
      "FORCE_HTTPS_URLS" = true;
      "APP_URL" = "https://iron.tail4aa8d.ts.net";
      "SESSION_SECURE_COOKIE" = true;
      "OPEN_REGISTRATION" = lib.mkForce true;
      "MAIL_DRIVER" = "log";
      "MAIL_MAILER" = "log";
    };
  };
}
