{ pkgs, ... }:
{
  programs.tmux.enable = true;
  programs.tmux.package = pkgs.wrappedPkgs.tmux;

  environment.systemPackages = with pkgs; [
    lf
  ];
}
