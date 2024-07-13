{
  lib,
  pkgs,
  modulesPath,
  inputs,
  system,
  ...
}:
{
  # systemd-profiles idea I had can now be achieved
  # mainly a server profile (no audio, gui, etc)
  # and multiple modes to choose from in boot menu
  specialisation = {
    hyprland = {
      inheritParentConfig = true;
      configuration = {
        programs.hyprland = {
          enable = true;
          package = inputs.hyprland.packages.${system}.hyprland;
        };
        services.desktopManager.plasma6.enable = lib.mkForce false;
        environment.systemPackages = [ pkgs.nwg-displays ];
      };
    };
    ly = {
      inheritParentConfig = true;
      configuration = {
        services = {
          displayManager.ly.enable = true;
          displayManager.ly.settings = {
            load = true;
            save = true;
          };
          displayManager.sddm.enable = lib.mkForce false;
          xserver.displayManager.lightdm.enable = lib.mkForce false;
        };
      };
    };
    xfce = {
      inheritParentConfig = true;
      configuration = {
        xdg.portal = {
          enable = true;
          gtkUsePortal = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        };
        services.xserver.desktopManager.xfce.enable = true;
        services.desktopManager.plasma6.enable = lib.mkForce false;
        environment.systemPackages = with pkgs; [
          plata-theme
          rofi
          xfce.thunar
          xfce.xfce4-whiskermenu-plugin
        ];
        programs.xfconf.enable = true;
      };
    };
    tty = {
      inheritParentConfig = true;
      configuration = {
        # The bug below with noXlibs occurs due to importing minimal profile
        # it fails to compile ghc-8.6
        imports = [ "${modulesPath}/profiles/minimal.nix" ];
        hardware.opentabletdriver.enable = lib.mkForce false;
        # https://github.com/NixOS/nixpkgs/issues/102137
        environment.noXlibs = lib.mkForce false;
        services = {
          xserver.enable = lib.mkForce false;
          displayManager.sddm.enable = lib.mkForce false;
          desktopManager.plasma6.enable = lib.mkForce false;
          flatpak.enable = lib.mkForce false;
          # TODO disable graphical profile
        };
      };
    };
    lemurs = {
      inheritParentConfig = true;
      configuration = {
        services = {
          displayManager.sddm.enable = lib.mkForce false;
          xserver.displayManager.lightdm.enable = lib.mkForce false;
          xserver.enable = true;
          displayManager.enable = true;
          lemurs = {
            enable = true;
            x11.enable = true;
            wayland.enable = true;
          };
          desktopManager.plasma6.enable = true;
        };
      };
    };
    tuigreet = {
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
  };
}
