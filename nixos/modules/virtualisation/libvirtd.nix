{ pkgs, ... }:
{
  # https://github.com/rhasselbaum/nixos-config/commit/e2fd02f4e080039cd5c48e2baa92500080a884e4
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
    };
  };
  programs.virt-manager.enable = true;
  users.users.rithvij.extraGroups = [ "libvirtd" ];
}
