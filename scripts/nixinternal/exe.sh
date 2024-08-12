# shellcheck shell=bash
# https://stackoverflow.com/a/64644990/8608146
_exe() {
  [ "$1" == on ] && {
    set -x
    return
  } 2>/dev/null
  [ "$1" == off ] && {
    set +x
    return
  } 2>/dev/null
  echo + "$@"
  "$@"
}
exe() {
  { _exe "$@"; } 2>/dev/null
}
