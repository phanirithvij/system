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
  programs.dprint.settings = {
    includes = [
      "**/*.{md,json,jsonc,toml,yml,yaml}"
      "*.{md,json,jsonc,toml,yml,yaml}"
    ];
    excludes = [
      "**/node_modules"
      "**/*-lock.json"
    ];
    plugins = [
      "https://plugins.dprint.dev/markdown-0.17.8.wasm"
      "https://plugins.dprint.dev/json-0.19.4.wasm"
      "https://plugins.dprint.dev/toml-0.6.3.wasm"
      "https://plugins.dprint.dev/g-plane/pretty_yaml-v0.5.0.wasm"
    ];
  };
}
