#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# shellcheck disable=SC1091
source "$SCRIPT_DIR"/nixinternal/onix.sh
# shellcheck disable=SC1091
source "$SCRIPT_DIR"/nixinternal/exe.sh

mkdir -p result

_exe onix build .#devShells.x86_64-linux.default -o result/shell

_exe onix build .#homeConfigurations."runner".activationPackage -o result/hm-runner
_exe onix build .#homeConfigurations."nixos@nixos".activationPackage -o result/hm-nixos
_exe onix build .#homeConfigurations."rithvij@iron".activationPackage -o result/hm-rithvij
_exe onix build .#homeConfigurations."rithviz@rithviz-inspiron7570".activationPackage -o result/hm-rithviz

_exe onix build .#systemConfigs.gha -o result/sysm.gha
_exe onix build .#systemConfigs.vps -o result/sysm.vps

_exe onix build .#nixosConfigurations.iron.config.system.build.toplevel -o result/h-iron
_exe onix build .#nixosConfigurations.defaultIso.config.system.build.isoImage -o result/h-iso

_exe onix bundle .#navi-master -o result/navi-master.bundled
#_exe onix bundle \
#  --bundler github:ralismark/nix-appimage \
#  .#navi-master \
#  -o result/navi-master-x86_64.AppImage

_exe onix build github:DavHau/nix-portable -o result/nix-portable
_exe onix bundle \
  --bundler github:DavHau/nix-portable \
  .#navi-master \
  -o result/navi-master-portable.bundled

_exe nix flake check
_exe nix fmt
#_exe nix run .#nix -- flake show
