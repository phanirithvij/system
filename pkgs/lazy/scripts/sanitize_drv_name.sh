#!/usr/bin/env bash

# Bash implementation of nixpkgs lib.strings.sanitizeDerivationName
# Converted from Nix to bash by Claude (Anthropic)
# Based on: nixpkgs lib.strings.sanitizeDerivationName

# shellcheck disable=SC2001 # nah

sanitize_derivation_name() {
  local string="$1"

  # Get rid of string context. This is safe under the assumption that the
  # resulting string is only used as a derivation name
  # (Note: bash strings don't have context, so this is a no-op)

  # Strip all leading "."
  string=$(echo "$string" | sed 's/^\.*//')

  # Split out all invalid characters
  # https://github.com/NixOS/nix/blob/2.3.2/src/libstore/store-api.cc#L85-L112
  # https://github.com/NixOS/nix/blob/2242be83c61788b9c0736a92bb0b5c7bbfc40803/nix-rust/src/store/path.rs#L100-L125
  # Replace invalid character ranges with a "-"
  string=$(echo "$string" | sed 's/[^[:alnum:]+._?=-]\+/-/g')

  # Limit to 211 characters (minus 4 chars for ".drv")
  if [ ${#string} -gt 207 ]; then
    string="${string: -207}" # Keep last 207 chars
  fi

  # If the result is empty, replace it with "unknown"
  if [ -z "$string" ]; then
    string="unknown"
  fi

  echo "$string"
}
