{ pkgs }:
# TODO treefmt too? merge both shells
pkgs.mkShell {
  packages = with pkgs; [
    nh
    nix-output-monitor
    xc
    statix
    deadnix
  ];
}
