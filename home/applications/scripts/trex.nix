{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "trex";
      runtimeInputs = with pkgs; [
        zstd
        coreutils
        asciinema
        pkgs.wrappedPkgs.tmux
      ];
      text = builtins.readFile ../../../scripts/trex.sh;
    })
  ];
}
