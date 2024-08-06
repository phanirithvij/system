{
  config,
  lib,
  pkgs,
  flake-inputs,
  ...
}:
let
  nameservers = [
    "1.1.1.1"
    "100.100.100.100"
    "8.8.8.8"
  ];
in
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/specialisations
    ../../nixos/profiles/desktop.nix
    ../../nixos/applications/tailscale.nix
    ../../nixos/applications/nix/nixserve
    ../../nixos/applications/nix/pr-tracker-service.nix
    ../../secrets
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      useOSProber = true;
      efiSupport = true;
      default = "saved";
      device = "nodev";
      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry "Poweroff" {
          halt
        }
      '';
    };
  };
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" ];
  };

  # REISUB
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };

  networking.hostName = "iron";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          "j+k" = "esc";
          "insert" = "noop";
          "rightcontrol" = "overload(control, sysrq)";
        };
      };
    };
  };

  # Enable CUPS to print documents.
  # TODO scanner stuff
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];

  # remove hp later TODO foss
  #services.printing.drivers = [ pkgs.gutenprint ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  powerManagement.powerUpCommands = ''
    ${lib.getBin pkgs.util-linux}/bin/rfkill unblock bluetooth
  '';

  hardware.opentabletdriver.enable = true;

  # TODO learn what rtkit is
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.flatpak.enable = true;
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.fwupd.enable = true;

  nix = {
    registry = {
      nixpkgs.flake = flake-inputs.nixpkgs;
      n.flake = flake-inputs.nixpkgs;
    };
    package = pkgs.nixFlakes;
    settings =
      let
        users = [
          "root"
          "rithvij"
          "hydra" # TODO maybe hydra needs @wheel
        ];
      in
      {
        allowed-uris = "github: gitlab: git+ssh:// https://github.com/";
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        trusted-users = [ "@wheel" ];
        allowed-users = users;
        sandbox = "relaxed";
        http-connections = 50;
        log-lines = 50;
        substituters = [
          "https://cosmic.cachix.org/"
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
    /*
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    */
  };
  nixpkgs.config.allowUnfree = true;

  # https://nixos.wiki/wiki/Podman
  virtualisation = {
    # waydroid.enable = true;
    docker = {
      enable = true;
      enableOnBoot = true;
      package = pkgs.docker_25;
      daemon.settings = {
        dns = nameservers;
      };
    };
  };
  hardware.nvidia-container-toolkit.enable = true;

  sops.secrets.rithvij_user_passwd = {
    neededForUsers = true;
  };

  users.users.rithvij = {
    isNormalUser = true;
    # Hint: my clash of clans username
    hashedPasswordFile = config.sops.secrets.rithvij_user_passwd.path;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "docker"
      "input"
    ];
  };

  # List packages installed in system profile.
  environment = {
    systemPackages = with pkgs; [
      wget2
      xclip

      gdu
      lf
      tmux # programs tmux

      fish # programs fish
      go
      fastfetch
      gparted
      tree
      upx

      zip
      xz
      unzip
      p7zip
      gnutar
      brotli

      file
      which
      sysz
      progress

      libsmbios
      dmidecode

      ddrescue
      ddrescueview

      btop # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring

      iptables
      #wacomtablet
      #xf86_input_wacom
      btrfs-progs

      smartmontools
      nvme-cli
      ksnip
      kdiskmark
    ];
    variables.EDITOR = "nvim";
    variables.VISUAL = "nvim";
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.neovim.enable = true;
  services.openssh.enable = true;
  services.pr-tracker.enable = true;

  services.redis = {
    package = pkgs.valkey;
    servers.redrum = {
      enable = true;
      port = 6379;
    };
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [
      "tailscale0"
      "wlp3s0"
      "enp0s20f0u1" # usb tethering
    ];
    allowedUDPPorts = [
      26439
      5159
    ];
    allowedTCPPorts = [
      26439
      3249
      5159
    ];
  };
  networking.nameservers = nameservers;

  # TODO headscale
  # TODO modularise all of these

  # not supported with flakes
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.05"; # Don't change this at all? Did you read the comment?
}
