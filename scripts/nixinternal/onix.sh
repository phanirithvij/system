# shellcheck shell=bash
function run_nom_command() {
  local cmd=$1
  shift
  local args=
  if [[ -z ${CI+x} ]]; then
    args=" --log-format internal-json 2>&1 | nom --json"
  fi
  eval "$cmd $* $args"
}

function onix() {
  run_nom_command "nix" "$@"
}

function onix-build() {
  run_nom_command "nix-build" "$@"
}

# TODO won't work?
# Register bash completion for onix and onix-build
if type _complete_nix >/dev/null 2>&1; then
  complete -F _complete_nix onix
  complete -F _complete_nix onix-build
fi
