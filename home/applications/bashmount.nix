{ pkgs, ... }:
{
  programs.bashmount.enable = true;
  programs.bashmount.package = pkgs.nurPkgs.bashmount;
}
