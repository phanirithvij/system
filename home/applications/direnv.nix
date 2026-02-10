_: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global.disable_stdin = true;
      global.strict_env = true;
      global.hide_env_diff = true;
    };
    # https://github.com/direnv/direnv/wiki/Customizing-cache-location
    # https://github.com/eljamm/nixos/blob/7d6b2f9a3274db385ca784f1917c61eac712e867/modules/nixos/system/programs.nix#L6C1-L26C1
    stdlib = # sh
      ''
        # Create a unique human-readable directory name per project in `~/.cache/direnv/layouts/`:
        #
        # NOTE:
        # - `direnv_layour_dir` is called once for every {.direnvrc,.envrc} sourced
        # - The indicator for a different direnv file being sourced is a different $PWD value
        # This means we can hash $PWD to get a fully unique cache path for any given environment

        : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            local hash path
            echo "''${direnv_layout_dirs[$PWD]:=$(
                hash="$(sha1sum - <<< "$PWD" | head -c40)"
                path="''${PWD//[^a-zA-Z0-9]/-}"
                echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
            )}"
        }
      '';
  };
}
