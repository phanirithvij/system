{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../modules/redis.nix
    ../modules/swapspace.nix
    ../modules/tmate-ssh-server.nix
    ../modules/cloudflared.nix
  ];
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";
    environment.systemPackages =
      # Now for macos (gha) maybe I can avoid system-manager
      # and use the following via home-manager
      assert lib ? mine; # ensure lib.mine propagates
      with pkgs;
      [ duf ]
      ++ [
        (writeShellScriptBin "dufi" ''
          CLICOLOR_FORCE=1 COLORTERM="truecolor" viddy --disable_auto_save -p -d -n 0.5 \
            "duf -only local,fuse -hide-mp /boot/efi -output \"mountpoint, avail, usage, inodes_avail, inodes_usage, filesystem\" -sort usage"
        '')
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        btop
        (writeShellScriptBin "mem" ''
          viddy -n 0.5 -d --disable_auto_save '
            sh -c "
              echo $ free -h; free -h; echo;
              echo $ zramctl; echo; zramctl; echo;
              echo $ swapon --show; echo; swapon --show
            "
          '
        '')
        sysz
      ];
    services.swapspace = {
      enable = true;
      settings.cooldown = 5;
    };
    services.redis = {
      package = pkgs.valkey;
      servers.redrum = {
        enable = true;
        port = 6379;
        user = "runner"; # TODO make it work with users.users.redis-redrum
      };
    };
    services.tmate-ssh-server.enable = true;
    services.tmate-ssh-server.host = "$(cat /etc/ngrok-tcp-hostname)"; # will work at runtime?
    # systemd.services.tmate-ssh-server.enable = lib.mkForce false; # TODO generate service file but disable?
  };
}
