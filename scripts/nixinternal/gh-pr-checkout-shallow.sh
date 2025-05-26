#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash gh gitMinimal jq
# shellcheck shell=bash

commit="$(gh pr view "$1" --json headRefOid | jq '.headRefOid' -r)"
git fetch --depth 1 origin "$commit"
git checkout FETCH_HEAD
