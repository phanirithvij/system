#!/usr/bin/env sh

nix flake check
nix fmt
nix run .#nix -- flake show

nom build .#devShells.x86_64-linux.default

nom build .#homeConfigurations."runner".activationPackage
nom build .#homeConfigurations."nixos@nixos".activationPackage
nom build .#homeConfigurations."rithvij@iron".activationPackage
nom build .#homeConfigurations."rithviz@rithviz-inspiron7570".activationPackage

nom build .#systemConfigs.gha
nom build .#systemConfigs.vps

nom build .#nixosConfigurations.iron.config.system.build.toplevel
nom build .#nixosConfigurations.defaultIso.config.system.build.isoImage
