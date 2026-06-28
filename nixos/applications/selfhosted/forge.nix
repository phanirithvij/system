{
  flake-inputs,
  system,
  ...
}:
{
  imports = [ flake-inputs.forge.packages.${system}.apps.ironcalc.nixosModules.default ];
}
