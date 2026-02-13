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
  # this enables all firmware
  # imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # default value is enableAllFirmware which is false by default
  # config.enableRedistributableFirmware = false;

  # TODO split up linux-firmware pacakge into
  # million little pieces like alpine or a few pieces like arch

  # TODO nixos-generate-config can have this scan?
  # sudo dmesg | rg 'Loading firmware.*(/nix/store/[a-z0-9]{32}-[^[:space:]]+)' -o -r '$1' | xargs -d'\n' -I{} realpath {}
  #   /nix/store/[...]-wireless-regdb-2025.02.20-zstd/lib/firmware/regulatory.db.zst
  #   /nix/store/[...]-wireless-regdb-2025.02.20-zstd/lib/firmware/regulatory.db.p7s.zst
  #   /nix/store/[...]-linux-firmware-20250627-zstd/lib/firmware/iwlwifi-7265D-29.ucode.zst
  #   /nix/store/[...]-linux-firmware-20250627-zstd/lib/firmware/i915/kbl_dmc_ver1_04.bin.zst
  # sudo dmesg | rg 'firmware .* failed with error'
  #   bluetooth hci0: Direct firmware load for intel/ibt-hw-37.8.10-fw-1.10.3.11.e.bseq failed with error -2
  #   bluetooth hci0: Direct firmware load for intel/ibt-hw-37.8.bseq failed with error -2

  # https://serverfault.com/questions/1026598/know-which-firmware-my-linux-kernel-has-loaded-since-booting
  # https://github.com/search?q=language%3ANix+dyndbg+AND+drivers%2Fbase%2Ffirmware_loader%2Fmain.c&type=code
  # https://github.com/NixOS/nixpkgs/issues/148197#issuecomment-1121407764
  #   https://github.com/samueldr/nixpkgs/commit/cbf7aa4ca386a7a0165aa0531772523760402861
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
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
}
