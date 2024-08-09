# shellcheck shell=bash
args=
if [[ -z ${CI+x} ]]; then
  args=" --log-format internal-json 2>&1 | nom --json"
fi
eval "nix $* $args"
