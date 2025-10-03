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
      base-arch =
        let
          binPkgs = lib.makeBinPath (
            with pkgs;
            [
              yay
              fzf
              (callPackage ./pacui.nix { })
            ]
          );
          bashrc =
            pkgs.writeText "temp-bashrc"
              #bash
              ''
                export PATH="/usr/bin:$HOME/.local/bin:$PATH"
                export PATH=$PATH${binPkgs}
              '';
        in
        {
          image = "archlinux:latest";
          additional_packages = "expac pacman-contrib";
          init_hooks = lib.strings.replaceStrings [ "\n" ] [ ";" ] (
            lib.strings.trim
              #bash
              ''
                export PATH="/usr/bin:''$HOME/.local/bin:''$PATH"
                # TODO some init script to source, maybe something already exists when entering distrobox
                # This is bad, because bashrc is my home-manager controlled #cat ${bashrc} >> ~/.bashrc
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
