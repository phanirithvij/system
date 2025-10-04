{
  lib,
  pkgs,
  config,
  ...
}:
{
  # this enables all firmware
  # imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # default value is enableAllFirmware which is false by default
  # config.enableRedistributableFirmware = false;

  # TODO nixos-generate-config can have this scan?
  # sudo dmesg | rg 'Loading firmware.*(/nix/store/[a-z0-9]{32}-[^[:space:]]+)' -o -r '$1' | xargs -d'\n' -I{} realpath {}
  #   /nix/store/[...]-wireless-regdb-2025.02.20-zstd/lib/firmware/regulatory.db.zst
  #   /nix/store/[...]-wireless-regdb-2025.02.20-zstd/lib/firmware/regulatory.db.p7s.zst
  #   /nix/store/[...]-linux-firmware-20250627-zstd/lib/firmware/iwlwifi-7265D-29.ucode.zst
  #   /nix/store/[...]-linux-firmware-20250627-zstd/lib/firmware/i915/kbl_dmc_ver1_04.bin.zst
  # sudo dmesg | rg 'firmware .* failed with error'
  #   bluetooth hci0: Direct firmware load for intel/ibt-hw-37.8.10-fw-1.10.3.11.e.bseq failed with error -2
  #   bluetooth hci0: Direct firmware load for intel/ibt-hw-37.8.bseq failed with error -2

  # hardware.firmwareCompression is zstd by default (it is auto, but for new kernels it is zstd)
  hardware.firmwareCompression = "none"; # disable because I do it myself, don't think it is idempotent
  # enabled in nixos/modules/services/networking/networkmanager.nix
  hardware.wirelessRegulatoryDatabase = lib.mkForce false; # I add the compressed version myself

  hardware.firmware = with pkgs; [
    (compressFirmwareZstd wireless-regdb)
    (stdenv.mkDerivation {
      phases = [
        "unpackPhase"
        "installPhase"
      ];
      name = "linux-firmware-filtered";
      src = compressFirmwareZstd linux-firmware; # can get this from official nixos cache
      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib/firmware
        pushd $src/lib/firmware || exit 1
        files=(
          iwlwifi-7265D-29.ucode*
          i915/kbl_dmc_ver1_04.bin*
          intel/ibt-hw-37.8.10-fw-1.10.3.11.e.bseq*
          intel/ibt-hw-37.8.bseq*
        )
        cp --no-preserve=mode --parents ''${files[@]} $out/lib/firmware
        chmod -w -R $out/lib/firmware
        popd || exit 1
        runHook postInstall
      '';
    })
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
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
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
