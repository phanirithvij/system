{ pkgs, ... }:
{
  imports = [ ../applications/syncplay.nix ];
  config = rec {
    nixpkgs.hostPlatform = "x86_64-linux";

    environment = {
      systemPackages = with pkgs; [
        # All hm, only systemd related should stay here I think
        # but for root user maybe this is the spot
        ripgrep
        fzf
        sysz
        lf
        lazygit
        tmux
      ];
    };

    services.syncplay.enable = true;
    #services.nginx.enable = true;
    #services.redis = {
    #  package = pkgs.valkey;
    #  servers.redrum = {
    #    enable = true;
    #    port = 6379;
    #  };
    #};
  };
}
