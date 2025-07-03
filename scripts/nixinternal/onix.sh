# shellcheck shell=bash
function run_nom_command() {
  local cmd=$1
  shift
  local args=
  if [[ -z ${CI+x} ]]; then
    # TODO nixify this script, so nom should be ${lib.getExe pkgs.nom}
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

export -f onix onix-build run_nom_command

# TODO won't work?
# Register bash completion for onix and onix-build
if type _complete_nix >/dev/null 2>&1; then
  complete -F _complete_nix onix
  complete -F _complete_nix onix-build
fi
