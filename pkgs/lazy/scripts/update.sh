#!/usr/bin/env bash

# TODO nixify shell scripts init and update
# add scripts to devshell

shopt -s nullglob

while IFS= LC_ALL=C read -r -d '' i; do
  # pname should be nixpkgs pname, can be dir or pname.desktop
  pname="$(basename "${i%.desktop}")"
  echo "updating $i"
  outDir=$(nix-build -E "with import <nixpkgs> { config.allowUnfree = true; }; $pname" --no-out-link)
  cp --no-preserve=mode -r "$outDir"/share/applications/*.desktop "$i"
done < <(find . -maxdepth 1 \( -type f -name '*.desktop' -o -type d ! -name '.' \) -print0)
