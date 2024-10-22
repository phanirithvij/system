{
  config,
  lib,
  pkgs,
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
    ../../nixos/applications/bandwidth.nix
    ../../nixos/applications/cloudflare.nix
    ../../nixos/applications/jellyfin.nix
    ../../nixos/applications/paperless.nix
    ../../nixos/applications/tailscale.nix
    ../../nixos/applications/touchpad.nix
    ../../nixos/applications/guix
    ../../nixos/applications/nix
    ../../nixos/applications/nix/nixserve
    ../../nixos/applications/nix/pr-tracker-service.nix
    ../../nixos/applications/ntfy-rss.nix
    ../../nixos/applications/spotify.nix
    ../../nixos/modules/virtualisation
    ../../secrets
  ];

  docker-opts.nameservers = nameservers;

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

  # Zram allows using part of ram as a swap device
  # thus will be very fast than any ssd and also compression
  # by default uses 50% of ram as swap, make it 90%
  # note the obvious: without compression it makes no sense to make ram into swap
  zramSwap = {
    enable = true;
    memoryPercent = 90;
  };
  services.swapspace = {
    enable = true;
    extraArgs = [
      "-P"
      "-v"
    ];
  };

  boot.kernel.sysctl = {
    # REISUB
    "kernel.sysrq" = 1;
    # reboot after panic=5 secs
    # see https://unix.stackexchange.com/q/29567 https://superuser.com/q/1853565
    "kernel.panic" = 5;
  };

  hardware.nvidia.open = true;
  hardware.nvidia-container-toolkit.enable = true;

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
    # https://reddit.com/r/linux/comments/1em8biv/comment/lgxtmck
    wireplumber.extraConfig = {
      "10-disable-camera" = {
        "wireplumber.profiles" = {
          main = {
            "monitor.libcamera" = "disabled";
          };
        };
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.xserver.enable = true;
  services.displayManager.ly.enable = lib.mkDefault true;
  services.displayManager.ly.settings = {
    load = true;
    save = true;
  };
  services.desktopManager.plasma6.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.fwupd.enable = true;
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
      "libvirtd"
    ];
  };

  # List packages installed in system profile.
  environment = {
    systemPackages = with pkgs; [
      wget2
      xclip

      ncdu
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
      btrfs-progs

      smartmontools
      nvme-cli
      kdiskmark

      ksnip
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
