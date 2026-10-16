# For collabora desktop
# From Fedi MIT. Copyright (c) 2026 @eljamm https://github.com/eljamm/nixos/blob/dev/modules/nixos/tools/ccache.nix
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.ccache;
in
{
  # Incremental Builds
  programs.ccache.enable = lib.mkDefault true;

  # TODO remove once https://github.com/NixOS/nixpkgs/pull/569444 is merged
  security.wrappers.nix-ccache.source = lib.mkForce (
    lib.getExe (
      (pkgs.writeCBin "nix-ccache" ''
        #include <err.h>
        #include <regex.h>
        #include <unistd.h>

        #define CCACHE "${lib.getExe pkgs.ccache}"

        int main(int argc, char *argv[]) {
          regex_t allowed;
          if (regcomp(&allowed, "^(-[CVsz]|--(clear|version|show-stats|zero-stats))$", REG_EXTENDED | REG_NOSUB))
            err(1, "regcomp");

          // if any arg isn't on the allowlist, run `ccache` w/o args
          for (int i = 1; i < argc; i++)
            if (regexec(&allowed, argv[i], 0, nullptr, 0))
              argv[1] = nullptr;

          argv[0] = CCACHE;
          execve(CCACHE, argv, (char *[]){ "CCACHE_DIR=${cfg.cacheDir}", nullptr });
          err(127, CCACHE);
        }
      '').overrideAttrs
        { env.NIX_CFLAGS_COMPILE = "-std=c23"; }
    )
  );

  nixpkgs.overlays = lib.mkIf cfg.enable [
    (_: super: {
      ccacheWrapper = super.ccacheWrapper.override {
        extraConfig = ''
          export CCACHE_DIR="${cfg.cacheDir}"
          export CCACHE_UMASK=007
          export CCACHE_NOCOMPRESS=true
          export CCACHE_MAXSIZE=10G
          export CCACHE_SLOPPINESS=random_seed
          if [ ! -d "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' does not exist"
            echo "Please create it with:"
            echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
            echo "  sudo chown ${cfg.owner}:${cfg.group} '$CCACHE_DIR'"
            echo "====="
            exit 1
          fi
          if [ ! -w "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
            echo "Please verify its access permissions"
            echo "====="
            exit 1
          fi
        '';
      };
    })
  ];

  nix.settings = lib.mkIf cfg.enable {
    extra-sandbox-paths = [ cfg.cacheDir ];
  };

  environment.systemPackages = [ pkgs.ccache ];
}
