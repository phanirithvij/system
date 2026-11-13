{
  flake-inputs,
  system,
  ...
}:
let
  forge = flake-inputs.forge.packages.${system};
in
{
  imports = [
    forge.apps.ironcalc.nixosModules.default
    forge.apps.hister.nixosModules.default
  ];
}
