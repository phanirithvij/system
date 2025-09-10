# https://github.com/nix-community/NixOS-WSL
# https://nix-community.github.io/NixOS-WSL/options.html
{ pkgs, ... }:
{
  imports = [
    # <nixos-wsl/modules> # non flake
    ../../nixos/applications/nix
    ../../secrets
  ];

  wsl.enable = true;
  wsl.defaultUser = "rithvij";

  environment = {
    systemPackages = with pkgs; [
      wget2
      lf
      lazygit
      tmux
    ];
    variables.VISUAL = "nvim";
  };
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  system.stateVersion = "25.05"; # no need to change
}
