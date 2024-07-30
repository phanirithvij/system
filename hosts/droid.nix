{ pkgs, flake-inputs, ... }:
{
  environment.packages = with pkgs; [
    neovim
    openssh
    which
    file
    procps
    killall
    #diffutils
    #findutils
    utillinux
    #tzdata
    hostname
    #man
    gnugrep
    #gnupg
    #gnused
    #gnutar
    #bzip2
    #gzip
    #xz
    #zip
    #unzip
    #nh #not in 23.11
    iproute2
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "23.11";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  time.timeZone = "Asia/Kolkata";

  home-manager = {
    backupFileExtension = "hm.bak";
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit flake-inputs;
    };

    config = ../home/nix-on-droid;
  };
}
