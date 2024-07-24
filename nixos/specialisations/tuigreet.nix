{ lib, pkgs, ... }:
{
  specialisation.tuigreet = {
    inheritParentConfig = true;
    configuration = {
      services = {
        displayManager.sddm.enable = lib.mkForce false;

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

        desktopManager.plasma6.enable = true;
        flatpak.enable = lib.mkForce false;
      };
    };
  };
}
