#shellcheck shell=bash

# https://nix.dev/manual/nix/2.18/advanced-topics/distributed-builds
# NOTE: `base64 -w0 /etc/ssh/ssh_host_ed25519_key.pub`
# OR:
ssh-keyscan -t ed25519 192.168.29.77 2>/dev/null | tail -n1 | awk '{print $2 " " $3}' | base64 -w0
