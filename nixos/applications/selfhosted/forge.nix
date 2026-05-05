{
  flake-inputs,
  system,
  ...
}:
let
  ironcalcModules = flake-inputs.forge.packages.${system}.ironcalc-app.nixos.modules;
in
{
  imports = [
    ironcalcModules.setup
    ironcalcModules.nimi
    ironcalcModules.packages
    ironcalcModules.extraConfig
  ];
}
