#!/usr/bin/env sh

nix flake check
nix fmt
nix run .#nix -- flake show

mkdir -p result

nom build .#devShells.x86_64-linux.default -o result/shell

nom build .#homeConfigurations."runner".activationPackage -o result/hm-runner
nom build .#homeConfigurations."nixos@nixos".activationPackage -o result/hm-nixos
nom build .#homeConfigurations."rithvij@iron".activationPackage -o result/hm-rithvij
nom build .#homeConfigurations."rithviz@rithviz-inspiron7570".activationPackage -o result/hm-rithviz

nom build .#systemConfigs.gha -o result/sysm.gha
nom build .#systemConfigs.vps -o result/sysm.vps

nom build .#nixosConfigurations.iron.config.system.build.toplevel -o result/h-iron
nom build .#nixosConfigurations.defaultIso.config.system.build.isoImage -o result/h-iso
