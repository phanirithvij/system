{ pkgs, ... }:
{
  home.packages = with pkgs; [
    android-file-transfer
    scrcpy
  ];
}
