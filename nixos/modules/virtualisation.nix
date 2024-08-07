{ pkgs, ... }:
{
  # https://github.com/rhasselbaum/nixos-config/commit/e2fd02f4e080039cd5c48e2baa92500080a884e4
  virtualisation.libvirtd = {
    qemu = {
      package = pkgs.qemu_kvm;
    };
  };
  programs.virt-manager.enable = true;
}
