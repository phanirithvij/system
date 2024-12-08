{ flake-inputs, pkgs, ... }:
let
  inherit (pkgs) lib;
  inherit (flake-inputs) wrapper-manager;
in
(wrapper-manager.lib {
  inherit pkgs;
  # https://github.com/viperML/dotfiles/blob/453f126d2831a61990867a90087f5ec8420fcc80/packages/default.nix#L104
  modules = lib.pipe (builtins.readDir ./.) [
    (lib.filterAttrs (_name: value: value == "directory"))
    builtins.attrNames
    (map (n: ./${n}))
  ];
  specialArgs = {
    inherit flake-inputs;
  };
}).config.build.packages
