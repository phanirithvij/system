{ pkgs, ... }:
{
  home.packages = with pkgs; [
    asciinema_3
    asciinema-agg
  ];
}
