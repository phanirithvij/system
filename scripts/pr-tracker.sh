#!/usr/bin/env bash

# TODO let it be, if systemd service fails use this
# -E PR_TRACKER_GITHUB_TOKEN= \
systemd-socket-activate \
  -l 0.0.0.0:8001 \
  pr-tracker \
  --remote origin \
  --mount pr-tracker \
  --path /home/rithvij/Projects/nixhome/nixpkgs \
  --user-agent 'pr-tracker (alyssais)' \
  --source-url https://git.qyliss.net/pr-tracker
