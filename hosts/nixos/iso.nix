{
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"

    ../../nixos/applications/scripts/nixos-enter-custom-script.nix
  ];
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.wireless.enable = lib.mkForce false;
  #networking.networkmanager.enable = true;

  users.users = {
    #nixos.extraGroups = [ "networkmanager" ];
    nixos.initialHashedPassword = lib.mkForce "nixos";
  };

  environment.systemPackages = with pkgs; [
    bashmount
    disko
    fzf
    lf
    lazygit
    parted
    ripgrep
  ];

  #services.openssh.enable = true;
  programs.tmux.enable = true;
  programs.neovim.enable = true;

  # there is a copy to ram option in grub so this is not needed
  #boot.kernelParams = [ "copytoram" ];
  # https://discourse.nixos.org/t/hardware-nvidia-open-is-used-but-not-defined-error-when-updating-nixos-flake-config/51359/4
  hardware.nvidia.open = false;
}
