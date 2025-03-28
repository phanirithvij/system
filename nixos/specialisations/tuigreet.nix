{ lib, pkgs, ... }:
{
  specialisation.tuigreet = {
    inheritParentConfig = true;
    configuration = {
      system.nixos.tags = [ "sp:tuigreet" ];
      services = {
        displayManager.ly.enable = lib.mkForce false;

        greetd = {
          enable = true;
          settings = {
            default_session.command = ''
              ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --time \
              --asterisks \
              --user-menu \
              --cmd startplasma-x11
            '';
          };
        };

        xserver.enable = true;
        xserver.displayManager.startx.enable = true;
        xserver.displayManager.lightdm.enable = lib.mkForce false;
      };
      desktopManagers.xfce.enable = lib.mkDefault true;
    };
  };
}
