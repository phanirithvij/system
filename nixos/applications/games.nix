{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    a-keys-path
    oh-my-git
  ];
  programs.steam.enable = true;
}
