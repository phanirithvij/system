{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "trex";
      runtimeInputs = with pkgs; [
        zstd
        coreutils
        asciinema_3
        pkgs.wrappedPkgs.tmux
      ];
      text = builtins.readFile ../../../scripts/trex.sh;
    })
  ];
}
