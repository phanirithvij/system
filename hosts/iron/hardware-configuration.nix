{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "uas"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
    "v4l2loopback"
  ];
  boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];
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
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
