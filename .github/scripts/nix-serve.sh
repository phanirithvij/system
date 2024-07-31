#!/usr/bin/env bash

nix-store --generate-binary-cache-key gha-magic-cache-2 cache-priv-key.pem cache-pub-key.pem
export NIX_SECRET_KEY_FILE=$PWD/cache-priv-key.pem
nix run nixpkgs#nix-serve -- --listen :5000 --daemonize
