{
  pkgs,
  ...
}:
{
  honey-home = pkgs.callPackage ./honey-home/package.nix { };
}
