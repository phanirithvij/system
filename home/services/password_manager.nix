# https://github.com/dfangx/nixos-config/blob/master/homeManagerModules/services/password_manager.nix

# https://reddit.com/r/KeePass/comments/1bor6zm/comment/kwsp65m
# https://keepassxc.org/docs/KeePassXC_UserGuide#_automatic_database_opening

{
  config,
  pkgs,
  lib,
  ...
}:
let
  passwordManager = "${lib.getExe' pkgs.keepassxc "keepassxc"}";
in
{
  options.password_mgr.enable = lib.mkEnableOption "Enable password_mgr";
  config = lib.mkIf config.password_mgr.enable {
    #home.sessionVariables.PSWD_MGR = "${passwordManager}";
    home.packages = [ pkgs.keepassxc ];

    xdg.dataFile."dbus-1/services/org.freedesktop.secrets.service" = {
      enable = true;
      text = ''
        [D-BUS Service]
        Name=org.freedesktop.secrets
        Exec=${passwordManager}
      '';
    };
  };
}
