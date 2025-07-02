{ pkgs, ... }:
{
  home.packages = pkgs.nurPkgs.leaves;
}
