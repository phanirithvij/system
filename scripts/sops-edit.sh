#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash ssh-to-age sops
# shellcheck shell=bash

SECRET_FILE=$1
SECRET_FILE=${SECRET_FILE:-secrets/secrets.yml}

if [ -f ~/.config/sops/age.key ]; then
  SOPS_AGE_KEY_FILE=~/.config/sops/age.key sops "$SECRET_FILE"
  exit 0
fi

if [ -f ~/.ssh/id_ed25519 ]; then
  f_p="$(mktemp)"
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 >"$f_p"
  SOPS_AGE_KEY_FILE="$f_p" sops "$SECRET_FILE"
  rm -f "$f_p"
else
  echo "no ssh key ~/.ssh/id_ed25519 or age key ~/.config/sops/age.key, lost it all?"
  exit 1
fi
