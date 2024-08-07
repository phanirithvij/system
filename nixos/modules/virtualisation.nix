{ pkgs, ... }:
{
  # https://github.com/rhasselbaum/nixos-config/commit/e2fd02f4e080039cd5c48e2baa92500080a884e4
  virtualisation.libvirtd = {
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true; # Doesn't actually run as root because of overriding config below.
      # We want to run as a specific user/group, not Nix's non-root default of `qemu-libvirtd`,
      verbatimConfig = ''
        namespaces = []
        user = "rithvij"
        group = "users"
      '';
    };
  };
  programs.virt-manager.enable = true;
}
