{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    (python3.withPackages (pp: with pp; [ requests ]))
    jq
    bash
  ];
}
