{ pkgs, ... }:
{
  xdg.configFile."fastfetch/config.jsonc".source = ./config/fastfetch/config.jsonc;
  home.packages = with pkgs.lazyPkgs; [
    fastfetch
    fx
    hledger
    k9s
    lazysql
    puffin
    iredis
    # TODO redis tuis
    # etc.
    # https://github.com/mat2cc/redis_tui
    # https://github.com/kyai/redis-cui
    # https://github.com/mylxsw/redis-tui
    # https://github.com/saltfishpr/redis-viewer
  ];
}
