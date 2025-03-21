#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
  echo "nix-prefetch-patch <url>"
  exit 1
fi
read -r -d '' expr <<EOF
with import <nixpkgs> {};
pkgs.fetchpatch {
  url = "$1";
  hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
}
EOF
nix-build --no-out-link -E "$expr" 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g'
