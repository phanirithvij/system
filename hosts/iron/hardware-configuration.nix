{
  lib,
  pkgs,
  config,
  flake-inputs,
  ...
}:
let
  modetc = import flake-inputs.modetc {
    inherit pkgs;
    linux = config.boot.kernelPackages;
  };
in
{
  #boot.kernelParams = [ ''dyndbg="file drivers/base/firmware_loader/main.c +fmp"'' ];

  # hardware.firmwareCompression is zstd by default (it is auto, but for new kernels it is zstd)
  hardware.firmwareCompression = "none"; # disable because I do it myself, don't think it is idempotent
  # enabled in nixos/modules/services/networking/networkmanager.nix
  hardware.wirelessRegulatoryDatabase = lib.mkForce false; # I add the compressed version myself

  hardware.firmware = with pkgs; [
    (compressFirmwareZstd wireless-regdb)
    pkgs.nurPkgs.linux-firmware-iron-zstd # custom filtered firmware files
    # (compressFirmwareZstd linux-firmware) # original nixpkgs equivalent
  ];

  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  # also https://github.com/NixOS/nixpkgs/pull/453196#issue-3528670010
  # thanks @eljamm for recommending this
  services.scx.scheduler = "scx_bpfland";
  services.scx.enable = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
    "v4l2loopback"
    "modetc"
  ];
  # 6.18.23 ok
  # 6.18.24 broken (kernel NULL)
  # 6.19.13 ok
  # 6.19.14 broken (kernel NULL)
  # 7.0     broken (runtime failure with ssh-add ~/.ssh/id_..)
  # 7.0.1   broken (kernel NULL)
  #boot.kernelPackages = pkgs.linuxPackages_6_19;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
    modetc.module
  ];
  boot.extraModprobeConfig = ''
    options modetc homedir=/home/rithvij default_rule=var/
  '';

  # TODO lots of weird limitations (16, default_rule, no regex, etc.)
  # TODO figure out how to do nix store path rewrites AS WELL with modetc
  # TODO multiple instances of this thing
  # NOTE: nix-profile required for home-manager
  # .var required for steam bwrap
  # let xdg compliant things stay the same, not worth it to move them
  environment.etc."modetc.conf".text = ''
    .nix-	.nix-
    .local	.local
    .config	.config
    .cache	.cache
    .var	.var
  '';

  boot.supportedFilesystems = [ "btrfs" ];
  # TODO blogpost of sort doing this migration step by step
  # ext4 to btrfs
  # reboot check everything works
  # come back and remove ext2_saved
  # optionally defrag+compress
  # TODO /nix, /home subvols empty / subvol (reset on each boot)
  # then disko for new installations?
  fileSystems."/" = {
    label = "nixroot";
    fsType = "btrfs";
    options = [
      "subvol=vols/@"
      "compress=zstd"
    ];
  };

  # TODO all this managed from outside this file
  # and use nixos-generate-config regularly
  # disko?
  fileSystems."/nix" = {
    label = "nixroot";
    fsType = "btrfs";
    options = [
      "subvol=vols/@nix"
      "noatime"
      "compress=zstd"
    ];
  };

  fileSystems."/home" = {
    label = "nixroot";
    fsType = "btrfs";
    # sops ssh secret defined in ~/.ssh
    neededForBoot = true;
    options = [
      "subvol=vols/@home"
      "compress=zstd"
    ];
  };

  # this could become persist
  # other dirs which are excluded in backups (all backups, except teldrive)
  fileSystems."/shed" = {
    label = "nixroot";
    fsType = "btrfs";
    options = [
      "subvol=vols/@shed"
      "compress=zstd"
    ];
  };

  fileSystems."/boot/efi" = {
    label = "boot";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # we're in the swapspace now
  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
