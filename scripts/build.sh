#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# shellcheck disable=SC1091
source "$SCRIPT_DIR"/nixinternal/onix.sh
# shellcheck disable=SC1091
source "$SCRIPT_DIR"/nixinternal/exe.sh

mkdir -p result

_exe onix build .#devShells.x86_64-linux.default -o result/shell --allow-import-from-derivation

_exe onix build .#homeConfigurations."runner".activationPackage -o result/hm-runner --allow-import-from-derivation
_exe onix build .#homeConfigurations."nixos@nixos".activationPackage -o result/hm-nixos --allow-import-from-derivation
_exe onix build .#homeConfigurations.rithvij.activationPackage -o result/hm-rithvij --allow-import-from-derivation
_exe onix build .#homeConfigurations.rithviz.activationPackage -o result/hm-rithviz --allow-import-from-derivation

_exe onix build .#systemConfigs.gha -o result/sysm.gha --allow-import-from-derivation
_exe onix build .#systemConfigs.vps -o result/sysm.vps --allow-import-from-derivation

_exe onix build .#nixosConfigurations.iron.config.system.build.toplevel -o result/h-iron --allow-import-from-derivation
#_exe onix build .#nixosConfigurations.wsl.config.system.build.toplevel -o result/h-wsl
_exe onix build .#nixosConfigurations.wsl.config.system.build.tarballBuilder -o result/h-wsl-tar-ball-script --allow-import-from-derivation
#_exe onix build .#nixosConfigurations.defaultIso.config.system.build.isoImage -o result/h-iso

_exe onix build --no-link --print-out-paths --allow-import-from-derivation --impure "$(
  nix flake show --json --allow-import-from-derivation --impure |
    jq '.packages."x86_64-linux"|keys[]' |
    xargs -I '{}' echo -en '.#packages.x86_64-linux.{} '
)"

#_exe onix bundle .#navi-master -o result/navi-master.bundled
#_exe onix bundle \
#  --bundler github:ralismark/nix-appimage \
#  .#navi-master \
#  -o result/navi-master-x86_64.AppImage

#_exe onix build github:DavHau/nix-portable -o result/nix-portable
#_exe onix bundle \
#  --bundler github:DavHau/nix-portable \
#  .#navi-master \
#  -o result/navi-master-portable.bundled

_exe nix flake check --allow-import-from-derivation
#_exe nix run .#nix -- flake show
