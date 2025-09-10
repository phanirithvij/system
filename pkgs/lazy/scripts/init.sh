#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
APPLICATIONS_DIR="$SCRIPT_DIR"/../desktopItems
TMPDIR_APPS="$(mktemp -d -t "lazy-apps-dir-XXXX")"
ROOT_DIR=$(git rev-parse --show-toplevel)

# see https://github.com/NixOS/nix/issues/7076
# nix-cli works not `nix cli` for passing --argstr
cp -r --no-preserve=all \
  "$(
    nix-build \
      "$SCRIPT_DIR/bundle-lazy-apps.nix" \
      --argstr gitRoot "$ROOT_DIR" \
      --no-out-link
  )"/* "$TMPDIR_APPS"

mkdir -p "$APPLICATIONS_DIR"
cp -rL "$TMPDIR_APPS"/* "$APPLICATIONS_DIR"
rm -rf "$TMPDIR_APPS"
