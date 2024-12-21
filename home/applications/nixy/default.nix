{
  flake-inputs,
  pkgs,
  system,
  ...
}:
{
  imports = [ ./nix.nix ];
  home.packages = with pkgs; [
    compose2nix
    pr-tracker
    flake-inputs.yaml2nix.packages.${system}.default
  ];
}
