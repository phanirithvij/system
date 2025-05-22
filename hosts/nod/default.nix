{
  pkgs,
  ...
}:
{
  imports = [ ]; # TODO ./sshd.nix
  environment.packages = with pkgs; [
    neovim
    openssh
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
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  time.timeZone = "Asia/Kolkata";

  user.shell = pkgs.fish; # chsh won't work

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
