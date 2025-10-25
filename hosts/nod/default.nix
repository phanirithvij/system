{
  lib,
  pkgs,
  ...
}:
let
  hostvars = import ./variables.nix;
in
{
  imports = [
    ./modules/sshd.nix
    ./modules/nix.nix
    ./modules/mosh.nix
    ./modules/et.nix # mosh alt
  ];
  environment.packages = with pkgs; [
    which
    file
    procps
    killall
    ncurses5
    #diffutils
    #findutils
    utillinux
    #tzdata
    hostname
    #man
    gnugrep
    #gnupg
    gnused
    #gnutar
    #bzip2
    #gzip
    #xz
    #zip
    #unzip
    iproute2
    wget
    curl
    aria2
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  environment.sessionVariables = hostvars;

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  time.timeZone = "Asia/Kolkata";

  user.shell = lib.getExe pkgs.fish; # chsh won't work

  # can't properly run tailscale without app, on later android versions
  # it's kind of possible see, https://github.com/termux/termux-packages/issues/10166
  # https://github.com/tailscale/tailscale/issues/8006

  # make tailscale work on nod
  # WARNING: didn't work, had to use <hostname>.tail4aa8d.ts.net in ssh config
  environment.etc."resolv.conf".text = lib.mkForce ''
    nameserver 100.100.100.100
    nameserver 1.1.1.1
    nameserver 8.8.8.8
  '';

  # TODO pkgs not passed?
  /*
    home-manager = {
      backupFileExtension = "hm.bak";
      # useGlobalPkgs = true;
      extraSpecialArgs = {
        hostname = "nod";
        username = "nix-on-droid";
        inherit flake-inputs;
      };
      sharedModules = hmSharedModules;
      config = ../../home/users/nix-on-droid;
    };
  */
}
