{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
let
  hostvars = import ./variables.nix;
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
    ../../nixos/modules/desktop-environments

    ../../nixos/applications/bandwidth.nix
    ../../nixos/applications/cloudflare.nix
    ../../nixos/applications/mediaserver.nix
    # ../../nixos/applications/paperless.nix
    # ../../nixos/applications/tailscale.nix
    ../../nixos/applications/touchpad.nix
    ../../nixos/applications/gpg.nix
    # ../../nixos/applications/guix # I don't use this
    ../../nixos/applications/nix
    ../../nixos/applications/nix/nixserve
    ../../nixos/applications/nix/selfhosted
    ../../nixos/applications/nix/pr-tracker-service.nix
    ../../nixos/applications/ntfy-rss.nix
    # ../../nixos/applications/opengist.nix
    ../../nixos/applications/selfhosted/qbittorrent.nix
    # ../../nixos/applications/spotify.nix
    ../../nixos/applications/tui.nix
    ../../nixos/applications/scripts/gh-pr-checkout-shallow.nix
    ../../nixos/modules/virtualisation
    ../../secrets

    # special module to keep nixos system flake's inputs
    ../../nixos/modules/nix-keep-flake-inputs.nix
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
      # btrfs can't have this feature of saving last booted entry
      # https://forum.manjaro.org/t/converting-ext4-root-to-btrfs-brings-up-grub-error-sparse-file-not-allowed/154491
      #default = "saved";
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
    #emulatedSystems = [ "aarch64-linux" ];
  };
  programs.nix-ld.enable = true;
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  services.nvme-rs.enable = true;

  # temporary, remove asap
  services.rustical.enable = true;
  # services.rustical.dataDir = "/shed/rusticalDir";

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
    settings.cooldown = 20;
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

  # TODO split up linux-firmware pacakge into
  # million little pieces like alpine or a few pieces like arch

  # https://serverfault.com/questions/1026598/know-which-firmware-my-linux-kernel-has-loaded-since-booting
  # https://github.com/search?q=language%3ANix+dyndbg+AND+drivers%2Fbase%2Ffirmware_loader%2Fmain.c&type=code
  # https://github.com/NixOS/nixpkgs/issues/148197#issuecomment-1121407764
  #   https://github.com/samueldr/nixpkgs/commit/cbf7aa4ca386a7a0165aa0531772523760402861
  boot.kernelParams = [ ''dyndbg="file drivers/base/firmware_loader/main.c +fmp"'' ];

  hardware.graphics = {
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };
  # TODO move all this hardware specific things to a module
  # eg. https://codeberg.org/mateidibu/nix-config/src/commit/c247b4525230271b77b37ee7259d5ef6c20aa11c/nixosModules/gpu-intel.nix#L11
  hardware.nvidia = {
    # open true will simply won't work for my gpu
    # but noveau works somehow?
    open = false;
    # this feels useless to me
    nvidiaPersistenced = true;
    # needs to be used with prime sync
    #modesetting.enable = true;
    # my gpu's driver can be production
    #package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    # https://discourse.nixos.org/t/struggling-with-nvidia-prime/13794/3
    prime = {
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
      offload.enable = true;
      # offload.enableOffloadCmd = true;
      # prime sync doesn't work shows only a mouse in a black screen
      #sync.enable = true;
    };
    # not supported on my gpu 940M
    #powerManagement.enable = true;
    #powerManagement.finegrained = true;
  };
  services.xserver.videoDrivers = [
    # without modesetting, x server will be run by nvidia
    # causes heating issues
    "modesetting"
    "nvidia"
  ];
  /*
    virtualisation.vmVariant.services.xserver.videoDrivers = lib.mkForce [
      "modesetting"
      "nvidia"
    ];
    virtualisation.vmVariantWithBootLoader.services.xserver.videoDrivers = lib.mkForce [
      "modesetting"
      "nvidia"
    ];
  */
  # The above are not taking effect
  hardware.nvidia-container-toolkit.enable = true; # TODO disable for vm and vmwithbootloader
  # https://bbs.archlinux.org/viewtopic.php?id=287207
  # https://gitlab.freedesktop.org/mesa/mesa/-/issues/11429#note_2560673
  # https://codeberg.org/mateidibu/nix-config/src/commit/c247b4525230271b77b37ee7259d5ef6c20aa11c/nixosModules/gpu-intel.nix#L25
  # my fence expiration timeout kernel panic bug
  # see if it changes anything
  # additional https://wiki.archlinux.org/title/Intel_graphics#X_freeze/crash_with_intel_driver
  boot.extraModprobeConfig = ''
    options i915 reset=1 enable_dc=0 enable_psr=0 enable_fbc=0
    options intel_idle max_cstate=1
  '';

  systemd.services."intel-gpu-frequency-max" = {
    description = "Set iGPU frequency to max";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.intel-gpu-tools}/bin/intel_gpu_frequency -m";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = hostvars.TimeZone;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # fonts.enableDefaultPackages = lib.mkForce false; # enabled in graphical-desktop.nix
  # TODO bloated, strace alacritty and wezterm to determine required font files
  # remove the rest, cache this package in nur
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  # https://github.com/NixOS/nixpkgs/issues/386413 | ladybird
  fonts.fontDir.enable = true;

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

  # TODO distrobox broken by this pr https://github.com/NixOS/nixpkgs/pull/407748
  # remove this hack after a fix
  security.lsm = lib.mkForce [ ];
  # TODO own nixos module audio.
  # useful with tty/buildserver modes
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
      # TODO discord mute to get a2dp profile, will it ever work?
      # actions.update-props."bluez5.autoswitch-profile" = true;
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
  desktopManagers.xfce.enable = lib.mkDefault true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.fwupd.enable = true;
  sops.secrets.rithvij_user_passwd = {
    neededForUsers = true;
  };

  # TODO muliple users each per directory
  # I may never do this because I never had the need for two users
  users.users.rithvij =
    assert lib ? mine; # Ensure lib.mine propagates
    {
      isNormalUser = true;
      # Hint: my clash of clans username
      hashedPasswordFile = config.sops.secrets.rithvij_user_passwd.path;
      extraGroups = [
        "wheel" # sudo group
        "video"
        "audio"
        "input"
        "networkmanager"
      ];
      shell = pkgs.fish;
    };
  programs.fish.enable = true;

  programs.lazy-apps.enable = true;

  # List packages installed in system profile.
  environment = {
    systemPackages = with pkgs; [
      wget2

      microfetch # TODO needed?

      zip
      unzip
      xz
      (p7zip.override { enableUnfree = true; })
      gnutar
      # pigz
      brotli
      peazip # TODO use the p7zip above instead of _7zz

      file
      tree
      ncdu
      gparted # Important
      upx

      which
      sysz
      progress

      libsmbios
      dmidecode
      acpilight # xbacklight

      ddrescue
      ddrescueview
      efibooteditor
      efibootmgr

      btop # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring

      iptables
      btrfs-progs
      compsize # btrfs compression stats

      smartmontools
      nvme-cli
      kdiskmark
      # TODO qdirstat with dark mode
      # qt5ct or something

      ksnip

      man-pages
      man-pages-posix

      # # offload.enableOffloadCmd yank
      nvidia-offload
    ];
    variables.VISUAL = "nvim";
    # TODO ssessionVariables vs vvariables what's the diff
    sessionVariables = {
      inherit (hostvars) OWN_DIR SYSTEM_DIR;
    };
  };
  # https://wiki.nixos.org/wiki/Man_pages
  documentation.dev.enable = true;
  documentation.man.enable = true;
  documentation.man.generateCaches = lib.mkForce false; # programs.fish enables it

  # comes enabled in graphical-desktop.nix module
  # don't need it, also takes up a good amount of space
  services.speechd.enable = lib.mkForce false;

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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };
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
      26439 # ??
      3249 # ??
      5159 # ??
      8096 # jellyfin
    ];
  };
  networking.nameservers = nameservers;
  networking.networkmanager.insertNameservers = [ "1.1.1.1" ];

  # TODO headscale
  # TODO modularise all of these

  # not supported with flakes
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.05"; # Don't change this at all
}
