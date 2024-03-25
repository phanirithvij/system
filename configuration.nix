{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
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
    emulatedSystems = ["aarch64-linux"];
    registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
  # REISUB
  boot.kernel.sysctl = { "kernel.sysrq" = 1; };

  networking.hostName = "iron";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services.xserver.enable = true;

  services.keyd.enable = true;
  services.keyd.keyboards.default = {
    ids = ["*"];
    settings = {
      main = {
        "j+k" = "esc";
        "insert" = "noop";
	"rightcontrol" = "overload(control, sysrq)";
      };
    };
  };

  # Enable CUPS to print documents.
  # TODO scanner stuff
  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  hardware.opentabletdriver.enable = true;

  # TODO learn what rtkit is
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.flatpak.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    settings = let
      users = ["root" "rithvij"];
    in {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = users;
      allowed-users = users;
      sandbox = "relaxed";
      http-connections = 50;
      log-lines = 50;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  # https://nixos.wiki/wiki/Podman
  virtualisation = {
    # waydroid.enable = true;
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users.rithvij = {
    isNormalUser = true;
    # Hint: my clash of clans username
    hashedPassword = "$y$j9T$CIlZr8283694QRRuk5LV61$2XLbPeB3WADV.jZLC7rXYGJ0GhZgGk7LQwyDXfI4dUD";
    extraGroups = ["wheel" "video" "audio" "networkmanager"];
    packages = with pkgs; [
      # TODO home-manager this stuff
      # TODO systemd-profiles idea I had can now be acheived with nix configurations in flakes
      android-file-transfer
      espanso
      aria
      rclone
      #adb android-tools is too fat and heavy
      scrcpy
      # docker podman docker-compose lazydocker
      distrobox
      # rustdesk-server
      # go
      # gup
      # distrobox-tui
      # remote-touchpad
      # nats
      # chihaya
      # templ
      # rustup
      cargo-binstall
      # mise
      # hyperfine
      # git-delta
      # fd-find
      # topgrade
      # neovide
      # cargo-zigbuild
      # gping
      # gitoxide
      # du-dust
      # bore-cli
      # coreutils
      # onefetch
      # tokei
      # zig
      # goteleport
      # tailscale
      #
      # caddy xcaddy with godaddy
      # nats cli server
      # jellyfin
      # openspeedtestserver
      # TODO devbox
      # hare?
      # hub
      # gh github-cli
      # yadm? chezmoi? dotdrop etc all unncessary with nix I think?
      # TODO home-manager with flakes
      # ntfy-sh
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim #programs neovim
    wget
    xclip

    gdu
    lf
    tmux #programs tmux

    fish #programs fish
    go
    git
    neofetch
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

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    libsmbios
    dmidecode

    ddrescue
    ddrescueview

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    #wacomtablet
    #xf86_input_wacom
    btrfs-progs

    # TODO remove this leter when I know enough about python packages building with venv, poetry, devenv whatnot per project
    python3
  ];

  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh.enable = true;

  services.redis.servers.redrum.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # not supported with flakes
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.05"; # Don't change this at all? Did you read the comment?
}
