#!/usr/bin/env bash

if ! command -v onix &>/dev/null; then
  function onix() {
    args=
    if [[ -z ${CI+x} ]]; then
      args=" --log-format internal-json 2>&1 | nom --json"
    fi
    eval "nix $* $args"
  }
fi

mkdir -p result

onix build .#devShells.x86_64-linux.default -o result/shell

onix build .#homeConfigurations."runner".activationPackage -o result/hm-runner
onix build .#homeConfigurations."nixos@nixos".activationPackage -o result/hm-nixos
onix build .#homeConfigurations."rithvij@iron".activationPackage -o result/hm-rithvij
onix build .#homeConfigurations."rithviz@rithviz-inspiron7570".activationPackage -o result/hm-rithviz

onix build .#systemConfigs.gha -o result/sysm.gha
onix build .#systemConfigs.vps -o result/sysm.vps

onix build .#nixosConfigurations.iron.config.system.build.toplevel -o result/h-iron
onix build .#nixosConfigurations.defaultIso.config.system.build.isoImage -o result/h-iso

onix bundle .#navi-master -o result/navi-master
onix bundle \
  --bundler github:ralismark/nix-appimage \
  .#navi-master \
  -o result/navi-master-x86_64.AppImage

nix flake check
nix fmt
nix run .#nix -- flake show
