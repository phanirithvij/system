_: {
  projectRootFile = "flake.nix";

  programs.nixfmt.enable = true;
  programs.deadnix.enable = true;
  programs.statix.enable = true;

  programs.shfmt.enable = true;
  programs.shellcheck.enable = true;

  programs.jsonfmt.enable = true;
  programs.yamlfmt.enable = true;

  # dprint broken with treefmt-nix, just install in nix-shell
  #programs.dprint.enable = true;

  # mdformat broken https://github.com/executablebooks/mdformat/issues/112
  # use manual dprint fmt
  #programs.mdformat.enable = true;
}
