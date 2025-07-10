{ pkgs, ... }:
{
  # TODO map over mkLazyApp to convert all leaves to lazy pkgs
  home.packages = pkgs.nurPkgs.leaves;
}
