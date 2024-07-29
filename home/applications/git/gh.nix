{ pkgs, ... }:
let
  gh-i = import ./gh-i.nix { inherit (pkgs) lib buildGoModule fetchFromGitHub; };
in
{
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    extensions = with pkgs; [
      gh-actions-cache
      gh-eco
      gh-f
      gh-i
      gh-s
      gh-notify
    ];
  };
  programs.gh-dash = {
    enable = true;
    settings = import ./gh-dash-config.nix;
  };
}
