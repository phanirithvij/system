{ lib, pkgs, ... }:
{
  imports = lib.filter (x: x != ./default.nix) (lib.filesystem.listFilesRecursive ./.);
  home.packages = [
    pkgs.lazyPkgs.simplescreenrecorder
  ];
}
