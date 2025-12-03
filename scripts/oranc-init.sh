#!/usr/bin/env bash

if [ ! -f oranc-test.key ]; then
        nix key generate-secret --key-name "oranc-test-key" >oranc-test.key
        cat oranc-test.key | nix key convert-secret-to-public >oranc-test.pub.key
fi

export ORANC_USERNAME="phanirithvij"
export ORANC_PASSWORD="${GITHUB_TOKEN:-"$(gh auth token)"}"
export GITHUB_USERNAME="phanirithvij"
ORANC_SIGNING_KEY="$(<"$PWD/oranc-test.key")"
export ORANC_SIGNING_KEY

# custom named var, oranc has no such thing
ORANC_NAMESPACE="oranc-test"
OCI_REPOSITORY="$GITHUB_USERNAME/$ORANC_NAMESPACE"

# priority is rank (low is prefered by nix)
oranc push --repository "$OCI_REPOSITORY" --allow-immutable-db initialize --priority 30

#nix-store -q --requisites ./result*
#nom build -f '<nixpkgs>' lazygit
#realpath -f ./result

#oranc push --repository "$OCI_REPOSITORY" --allow-immutable-db

nom build \
        github:nixos/nixpkgs/nixpkgs-unstable#path \
        --no-link --print-out-paths |
        sudo oranc push \
                --repository "$OCI_REPOSITORY" \
                --already-signed --excluded-signing-key-pattern '^$'
