_: {
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true;
  #programs.dprint.enable = true;
  programs.shfmt.enable = true;
  # this will always fail, run it once in a while and fix issues in shell scripts
  programs.shellcheck.enable = true;
}
