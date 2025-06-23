{ pkgs, ... }:
{
  wrappers.lf = {
    basePackage = pkgs.lf;
    prependFlags = [
      "-config"
      ./lfrc
    ];
  };
}
