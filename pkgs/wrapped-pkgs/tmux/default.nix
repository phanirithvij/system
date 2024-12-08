{ pkgs, ... }:
let
  inherit (pkgs) replaceVars;
in
{
  wrappers.tmux = {
    basePackage = pkgs.tmux;
    flags = [
      "-f"
      (replaceVars ./tmux.conf {
        resize-hook-script = ./resize-hook.sh;
      })
    ];
    pathAdd =
      [
        pkgs.valkey # redis-cli
      ]
      ++ (with pkgs.tmuxPlugins; [
        battery
      ]);
  };
}
