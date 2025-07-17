{
  pkgs,
  lib,
  hostname,
  ...
}:
let
  hostvars = import ../../../hosts/${hostname}/variables.nix;
in
{
  home.packages = [
    # since distrobox-tui-dev is the one I develop
    (lib.lowPrio pkgs.distrobox-tui)
  ];
  programs.distrobox = {
    enable = true;
    enableSystemdUnit = true;
    containers = {
      promnesia-arch = {
        image = "archlinux:latest";
        additional_packages = "python python-pipx";
        init_hooks = lib.strings.replaceStrings [ "\n" ] [ ";" ] (
          lib.strings.trim
            #bash
            ''
              pipx install 'promnesia[all]' 'hpi[optional]'
              export PATH="/usr/bin:''$HOME/.local/bin:''$PATH"
              promnesia serve &
            ''
        );
        start_now = true;
        replace = true; # set to true for containers which need to always get recreated
      };
    };
  };
  systemd.user.services.distrobox-home-manager.Service.Environment = [
    "DBX_CONTAINER_MANAGER=${hostvars.DBX_CONTAINER_MANAGER}"
  ];
}
