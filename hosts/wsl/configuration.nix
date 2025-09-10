# https://github.com/nix-community/NixOS-WSL
# https://nix-community.github.io/NixOS-WSL/options.html
{ pkgs, ... }:
{
  imports = [
    # <nixos-wsl/modules> # non flake
    ../../nixos/applications/nix
    ../../nixos/applications/tui.nix
    ../../secrets
  ];

  wsl.enable = true;
  wsl.defaultUser = "rithvij";

  users.users = {
    rithvij.isNormalUser = true;
    nixos.isNormalUser = true;
    nixos.group = "nixos";
  };
  users.groups.nixos = { };

  environment = {
    systemPackages = with pkgs; [
      wget2
      wget
      curl
    ];
    variables.VISUAL = "nvim";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  system.stateVersion = "25.05"; # no need to change
}
