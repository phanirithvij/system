{ pkgs }:
_: {
  projectRootFile = "flake.nix";

  programs.nixfmt.enable = true;
  programs.deadnix.enable = true;
  programs.statix.enable = true;

  programs.shfmt.enable = true;
  programs.shellcheck.enable = true;

  programs.stylua.enable = true;

  # mdformat broken https://github.com/executablebooks/mdformat/issues/112
  # use manual dprint fmt
  #programs.mdformat.enable = true;

  programs.dprint.enable = true;
  programs.dprint.package = pkgs.wrappedPkgs.dprint;
  programs.dprint.settings = {
    includes = [
      "**/*.{md,json,jsonc,toml,yml,yaml}"
      "*.{md,json,jsonc,toml,yml,yaml}"
    ];
    excludes = [
      "**/node_modules"
      "**/*-lock.json"
    ];
  };
}
