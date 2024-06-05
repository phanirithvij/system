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
  networking.networkmanager.enable = true;

  users.users = {
    nixos.extraGroups = [ "networkmanager" ];
  };

  # TODO home-manager
  # navi cheats with nix bookmarks
  # tmux config
  # document all of it
  environment.systemPackages = with pkgs; [
    disko
    neovim
    parted
    lf
    git
    gh
    lazygit
    bashmount
    tmux
  ];
}
