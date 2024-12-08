{ pkgs, ... }:
{
  wrappers.lf = {
    basePackage = pkgs.lf;
    flags = [
      "-config"
      ./lfrc
    ];
  };
}
