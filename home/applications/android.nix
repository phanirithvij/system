{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lazyPkgs.android-file-transfer
    lazyPkgs.scrcpy
  ];
}
