/*
  From https://github.com/rnl-dei/nixrnl/blob/master/profiles/proxy-cache.nix Licensed MIT
  Modified with the help of claude https://claude.ai/share/3352af68-3276-4b50-91d9-d41c332330d2

  Not being used by me, but I plan to.
*/
{
  pkgs,
  config,
  ...
}:
{
  networking.fqdn = "localhost:3239";
  services.caddy = {
    enable = true;
    # TODO move to nur-pkgs and overlay it
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddyserver/cache-handler@v0.16.0" ];
      hash = "sha256-MOYlZf6ZIi+w0HSbZ1UtV+JnQl3qo4KbaBYlEyne9Tw=";
    };
    virtualHosts."proxy-cache.${config.networking.fqdn}" = {
      extraConfig = ''
        # Nix cache info endpoint
        @nix_cache_info path /nix-cache-info
        handle @nix_cache_info {
          header Cache-Control "public, max-age=300"
          reverse_proxy https://cache.nixos.org {
            header_up Host cache.nixos.org
          }
        }

        # NAR files (the actual packages)
        @nar path /nar/*
        handle @nar {
          header Cache-Control "public, max-age=31536000, immutable"
          reverse_proxy https://cache.nixos.org {
            header_up Host cache.nixos.org
          }
        }

        # Narinfo files (metadata about packages)
        @narinfo path *.narinfo
        handle @narinfo {
          header Cache-Control "public, max-age=86400"
          reverse_proxy https://cache.nixos.org {
            header_up Host cache.nixos.org
          }
        }

        # Fallback for other requests
        reverse_proxy https://cache.nixos.org {
          header_up Host cache.nixos.org
        }
      '';
    };
  };

  # Optional: Configure Caddy's built-in file cache
  # Note: Caddy doesn't have persistent disk caching by default like nginx proxy_store
  # You'd need to use a separate caching layer or external plugin
}
