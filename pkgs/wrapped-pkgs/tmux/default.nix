{ pkgs, ... }:
let
  inherit (pkgs) replaceVars;
in
{
  wrappers.tmux = {
    basePackage = pkgs.tmux.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        ./0001-Revert-Expand-formats-with-the-pane-modifier-in-tree.patch
      ];
    });
    prependFlags = [
      "-f"
      (replaceVars ./tmux.conf {
        resize-hook-script = ./resize-hook.sh;
        fish = "${pkgs.fish}/bin/fish";
      })
    ];
    pathAdd = [
      pkgs.valkey # redis-cli
    ]
    ++ (with pkgs.tmuxPlugins; [
      battery
    ]);
  };
}
