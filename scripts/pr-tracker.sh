#!/usr/bin/env bash

# let it be, if systemd service fails use this

PR_TRACKER_GITHUB_TOKEN=""
# shellcheck source=/dev/null
source "@gh_t_pr_tracker_path@"
export PR_TRACKER_GITHUB_TOKEN

systemd-socket-activate \
  -l 0.0.0.0:8001 \
  -E PR_TRACKER_GITHUB_TOKEN="$PR_TRACKER_GITHUB_TOKEN" \
  pr-tracker \
  --remote origin \
  --mount pr-tracker \
  --path /home/rithvij/Projects/nixhome/nixpkgs \
  --user-agent 'pr-tracker (alyssais)' \
  --source-url https://git.qyliss.net/pr-tracker
