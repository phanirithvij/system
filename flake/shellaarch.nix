{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    nh
    xc
    statix
    deadnix
  ];
}
