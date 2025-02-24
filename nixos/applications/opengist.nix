{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) applyPatches opengist;
  # https://github.com/jshcmpbll/jsh-nix/blob/master/lib/home-file.nix
  # https://github.com/jshcmpbll/jsh-nix/blob/master/dots/apple-cursor.nix
  link = src: target: {
    "${target}"."L+" = {
      user = "opengist";
      group = "users";
      mode = "0770";
      argument = "${src}";
    };
  };
in
{
  sops.secrets.opengist_secrets_file = { };
  sops.secrets.opengist_pgsql_db_pass = { };
  systemd.tmpfiles.settings.opengist-custom-files = lib.mkMerge (
    map ({ s, t }: link s t) [
      {
        s = ./opengist-default.svg;
        t = "/var/lib/opengist/custom/icon.svg";
      }
    ]
  );
  services.opengist = {
    enable = true;
    # allows access to /var/lib/opengist to "users"
    group = "users";
    # allows w access to /var/lib/opengist
    readonly-home = false;
    settings = {
      "custom.logo" = "icon.svg";
      "custom.static-links" = [
        {
          name = "docs";
          path = "https://github.com/thomiceli/opengist/blob/stable/config.yml";
        }
        {
          name = "nix";
          path = "https://search.nixos.org/options?channel=unstable&query=services.opengist.settings";
        }
      ];
    };
    database = {
      port = 3306;
      type = "mysql";
      #port = 5432;
      #type = "postgresql";
      username = "opengist";
      name = "opengist";
      host = "localhost";
      passwordFile = config.sops.secrets.opengist_pgsql_db_pass.path;
    };
    # has OG_SECRET_KEY=?
    secretsFile = config.sops.secrets.opengist_secrets_file.path;
    environment = {
      OG_LOG_LEVEL = "debug";
    };
    package =
      let
        # one step away from IFD should not import src
        patchedSrc =
          p:
          applyPatches {
            inherit (p) src;
            # icon is not worth it to patch anymore
            # leaving this skeleton for ease of patching in future
            patches = [ ];
          };
        frontend' = opengist.passthru.frontend.overrideAttrs (p: {
          # custom profile picture
          postPatch = ''
            cp ${./opengist-default.svg} public/avatar.svg
          '';
          src = patchedSrc p;
        });
      in
      opengist.overrideAttrs (p: {
        postPatch = ''
          cp -R ${frontend'}/public/{manifest.json,assets} public/
        '';
        src = patchedSrc p;
      });
  };
}
