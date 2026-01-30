{
  pkgs,
  flake-inputs,
  system,
  ...
}:
{
  imports = [ ./nix.nix ];
  home.packages = with pkgs; [
    compose2nix
    #pr-tracker #should be autoadded via nurpkgs
    nurPkgs.flakePkgs.yaml2nix
    flake-inputs.nix-patcher.packages.${system}.nix-patcher
    lazyPkgs.nixfmt
    lazyPkgs.nixpkgs-review
    lazyPkgs.nix-eval-jobs
  ];
}
