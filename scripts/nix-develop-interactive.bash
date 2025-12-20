#!/usr/bin/env bash

# https://discourse.nixos.org/t/nix-build-phases-run-nix-build-phases-interactively/36090
# https://jade.fyi/blog/building-nix-derivations-manually/
# https://github.com/imincik/nix-utils

# Interactively run Nix build phases.
# This script must be sourced in Nix development shell environent !

# USAGE:
# mkdir dev; cd dev
# nix develop nixpkgs#<PACKAGE>
# source nix-develop-interactive.bash

SHELL=$(which bash)
export SHELL

# make sure that script is sourced
(return 0 2>/dev/null) && sourced=1 || sourced=0
if [ "$sourced" -eq 0 ]; then
  echo -e "ERROR, this script must be sourced (run 'source $0')."
  exit 1
fi

# make sure that script is sourced from nix shell
(type -t genericBuild &>/dev/null) && in_nix_shell=1 || in_nix_shell=0
if [ "$in_nix_shell" -eq 0 ]; then
  echo -e "ERROR, this script must be sourced from nix shell environment (run 'nix develop nixpkgs#<PACKAGE>')."
  return 1
fi

# TODO fzf tui? (some source <tmpfile>.sh every run?)
# rust/zig/go whatever, they can generate commands to source in the nix-shell (like zoxide init bash)
# or write a new shell which can execve commands and show in the outer shell
# given a lib.fileset -> symlink tree to original paths (mkoutofstoresymlink adjacent?)
#   relative to file's position? why is src so akward to use ../../. maybe have some way to pass auto src to files like callpackage
#   fileset root does it work with ../.. or just ./.?
# shell arg or env var to allow localBuild (skip unpack and rely on proper source mapping maybe src=. or src=filesetSymlinkTree)
#   for all derivations which have relative sources
#   for all derivations which have sources like fetchfrom... don't alter those?
#   cntr and `repl ? false` with --arg repl true come to mind
#     but nix develop can't accept --arg I think
# e.g. customUnpackPhase added to prePhases
# or set dontUnpack true
# custom out if legacy nix shell
# detect if in nix-shell vs nix develop -f . or flakes
#   see /nix/store presense in $out before overriding it
# Am i just looking for storeDir = ./. instead of /nix/store?
#   NO
#   unique hash prefix for development projects are blockers for me, they will lose local build cache
#   rebuilds of the world due to custom store dir are unacceptable they will lose binary cache
#   better nix-portable? https://github.com/Ninlives/relocatable.nix/blob/main/template.sh
#     nix-portable needs proot or bubblewrap but not relocatable.nix?
# numtide/build-go-cache? but not really..

# phases detection taken from
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/setup.sh
all_phases="${prePhases[*]:-} unpackPhase patchPhase ${preConfigurePhases[*]:-} \
    configurePhase ${preBuildPhases[*]:-} buildPhase checkPhase \
    ${preInstallPhases[*]:-} installPhase ${preFixupPhases[*]:-} fixupPhase installCheckPhase \
    ${preDistPhases[*]:-} distPhase ${postPhases[*]:-}"

# run phases
# shellcheck disable=SC2048
for phase in ${all_phases[*]}; do
  phases_pretty=$(echo "${all_phases[*]}" | sed "s|$phase|**$phase**|g" | tr -s '[:blank:]')
  echo -e "\n>>> Phase:   $phases_pretty"
  echo ">>> Command:  runPhase $phase"
  echo ">>> Press ENTER/s to skip, q/ctrl+c to quit, r to run"
  read -n 1 -r input
  echo

  case $input in
  [Rr])
    runPhase "$phase"
    ;;
  [Qq])
    break
    ;;
  *)
    echo "Skipping..."
    ;;
  esac
done
