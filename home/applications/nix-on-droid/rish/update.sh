#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash gh jq nix-update
# shellcheck shell=bash

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

owner=RikkaApps
repo=Shizuku

get_latest() {
  gh release --repo "$owner/$repo" list \
    --exclude-pre-releases \
    --limit 1 \
    --json tagName \
    --jq '.[].tagName'
}

tag="${1:-$(get_latest)}"
info=$(
  gh release view --repo "$owner/$repo" "$tag" \
    --json assets \
    --jq '.assets.[] | select(.name | endswith(".apk"))'
)
apkName=$(echo "$info" | jq -r '.name')
buildDate=$(echo "$info" | jq -r '.updatedAt')
buildDate="${buildDate%T*}"

sed -i "s/apkName = \".*\"; # .*/apkName = \"$apkName\"; # $buildDate/" package.nix

nix-update --version="${tag:1}" rish
