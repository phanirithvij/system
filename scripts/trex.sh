#!/usr/bin/env bash

file="$HOME/Videos/tmux/$(date +"%Y-%m")/$(date +"%Y-%m-%dT%H%M")_rec.cast"

asciinema rec -c tmux "$file"

pushd "$(dirname "$file")" || exit 1
zstd -22 --ultra -f "$file" && rm "$file"
popd || exit 1
