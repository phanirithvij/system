{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.timetagger;
in
{
  options.services.timetagger = {
    enable = lib.mkEnableOption "Timetagger";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.timetagger.override { port = 8082; };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.timetagger = {
      Unit = {
        Description = "Timetagger daemon";
      };
      Service = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
