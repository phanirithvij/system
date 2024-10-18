{ config, pkgs, ... }:
{
  imports = [
    ../modules/redis.nix
    ../modules/swapspace.nix
  ];
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";
    environment.systemPackages = with pkgs; [
      btop
      duf
      fzf
      gdu
      lf
      lazygit
      neovim
      viddy
      ripgrep
      sysz
      tmux
      nix-output-monitor
      nixfmt-rfc-style
      (writeShellScriptBin "mem" ''
        viddy -n 0.5 -d --disable_auto_save '
          sh -c "
            echo $ free -h; free -h; echo;
            echo $ zramctl; echo; zramctl; echo;
            echo $ swapon --show; echo; swapon --show
          "
        '
      '')
      (writeShellScriptBin "dufi" ''
        CLICOLOR_FORCE=1 COLORTERM="truecolor" viddy --disable_auto_save -p -d -n 0.5 \
          "duf -only local,fuse -hide-mp /boot/efi -output \"mountpoint, avail, usage, inodes_avail, inodes_usage, filesystem\" -sort usage"
      '')
    ];
    services.swapspace.enable = true;
    services.redis = {
      package = pkgs.valkey;
      servers.redrum = {
        enable = true;
        port = 6379;
        user = "runner"; # TODO make it work with users.users.redis-redrum
      };
    };
  };
}
