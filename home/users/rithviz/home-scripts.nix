_: {
  imports = [
    ../../applications/scripts/onix.nix
    ../../applications/scripts/pr-tracker-hm-script.nix
    ../../applications/scripts/sops-edit-hm-script.nix
    ../../applications/scripts/nix-prefetch-patch.nix

    # TODO decide, does it make sense? maybe with system-manager if it ever gets specialisations
    # ../../applications/scripts/home-manager-switch-specialisation.nix
  ];
}
