{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-output-monitor
    nvd
    # nh # not in 23.11 for nod
  ];
}
