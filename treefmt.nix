{ pkgs }:
_: {
  projectRootFile = "flake.nix";

  programs.nixfmt.enable = true;
  programs.deadnix.enable = true;
  programs.statix.enable = true;

  programs.shfmt.enable = true;
  programs.shellcheck.enable = true;

  programs.black.enable = true;

  # mdformat broken https://github.com/executablebooks/mdformat/issues/112
  # use manual dprint fmt
  #programs.mdformat.enable = true;

  programs.dprint = {
    enable = true;
    includes = [
      "**/*.{md,json,jsonc,toml,yml,yaml}"
      "*.{md,json,jsonc,toml,yml,yaml}"
    ];
    excludes = [
      "**/node_modules"
      "**/*-lock.json"
    ];
    settings = {
      plugins = pkgs.dprint-plugins.getPluginList (
        ps: with ps; [
          dprint-plugin-json
          dprint-plugin-markdown
          dprint-plugin-toml
          g-plane-pretty_yaml
          (import ./pkgs/dprint/plugins.nix { inherit pkgs; })
        ]
      );
    };
  };
}
