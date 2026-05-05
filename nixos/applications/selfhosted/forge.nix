{
  flake-inputs,
  system,
  ...
}:
{
  imports = [ flake-inputs.forge.packages.${system}.ironcalc-app.nixosModules.default ];
}
