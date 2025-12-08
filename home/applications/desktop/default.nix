{ lib, ... }:
{
  imports = lib.filter (x: x != ./default.nix) (lib.filesystem.listFilesRecursive ./.);
}
