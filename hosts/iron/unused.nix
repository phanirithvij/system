{
  boot.loader.grub = {
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
      menuentry "Firmware Settings" {
        fwsetup
      }
    '';
  };
}
