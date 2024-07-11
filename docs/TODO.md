# system

main system configuration including other whacky ideas
more are in my zet but that is to be made public

## TODO

### ideas

- [ ] github board like https://github.com/users/kachick/projects/3?query=sort%3Aupdated-desc+is%3Aopen
  - would prefer something selfhosted (find one)
  - for now settle on this todo.md
  - link to private notes msft to tasks.org migration
  - logseq? but I need reminders and alarms
  - zet and secondbrain ofc but still todo tracker is different?
- [ ] checkout jj, git alternative
- [ ] bookmarks
  - [ ] remove xc? somehow get navi cheats to work via cli without duplication
    - nix attrsets for commands and converted to navi, espanso, etc? or ref by id/slug each command?
    - or just yaml -> json -> nix lib.importJSON/builtins.fromJson
      - builtins.fromyaml non-existent, there's an open pr NixOS/nix#7340
    - raw text for cheats, etc
  - [ ] buku
    - webserver as nixos service and sysm service
  - [ ] espanso (outside shell or when navi is not enough)
    - buku so I can not have a flocuss folder incident
      - buku has no nested folders???
    - navi so I can paste navi commands online?
  - [ ] All these useful nix commands in navi/tmuxp/dmux/espanso/jupntbks/mprocs
    - Under home-manager bookmarks
    - Also nh tool is useful
      - comes with nom, nvd integration
    - hm switch
    - nixos switch
    - nix profile
    - nix-shell, nix shell
    - nix-shell with python jupyerlab
    - detsys nix install script
- [ ] secrets+passwords+privaterepos
  - sops secrets, age? o.O
  - authpass so I can paste passwds online
    - optional espanso integration
  - gopass + lesspass (gopass-hibp?)
    - lesspass db server rockpass, lesspass.rs
  - whacky: gopass totp, gopass reads .kdbx?
  - clone private repos to respective dirs auto
  - [ ] https://github.com/ItalyPaleAle/hereditas
    - incase I go bye bye
    - or a simple pdf doc in a pendrive?
  - [ ] ssh keys, ssh certs
  - yubikey try

### docs

- [ ] split docs per topic, esp secrets, bookmarks (notes mainly)
  - part of own wiki after a topic is done
  - own wiki like wiki.nikiv.dev
  - maybe see hugo, srid/emanote, Xe site with mdx typsit
- [ ] NOTES.md or my own documentation
- [ ] SETUP.md for initial setup
  - also setup secrets and private repos
  - Make it clear repo is only for me
  - [ ] initial installation setup for nixos and non-nixos linux
  - Scripts and writeups
    - navi, writeshellscriptBin, nh
  - Bootstrapping nix
    - Comes with iso for nixos minimal iso
    - DeterminateSystems nix installer on non-nixos
  - Bootstrapping home-manager
    - `nix run home-manager/master --extra-experimental-features "nix-command flakes" -- switch --flake /home/rithvij/Projects/system#rithvij`
    - To bootstrap home.nix config [see here](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone)
      - `nix run home-manager/master -- init #--switch`
- [ ] glossary
  - sysm
  - hm
- [ ] toc

### system (one and only inspiron7570 or iron)

#### iron nixos

- [ ] expect installed in profile, move it to nixos system
  - reason: nixpkgs broken due to python update, wait till the issues are resolved
- [ ] modules, profiles, apps, packages
  - see https://github.com/Guanran928/flake
  - allows others to import? more importantly I can import from outside
  - own pkgs repo, synced with nixpkgs auto pr if own gha successful?
  - nur + ff extensions
- [ ] home-manager for different hosts
  - shared /nix partition r/w?
    - garbage collection might get fked
      - gha cache to the rescue?
    - use ext drive as backup nix store and nix-serve it when detected?
      and use as another trusted substitutor?
      - and never gc it?
      - makes no sense, substitutor won't solve the space issue
        - nfs mount?
- [ ] minimal profile
  - remove alsa, 32bit
  - documentation enable false
  - man pages
- [ ] mouse heavy wf
  - awesomewm
  - dunst
- [ ] flake compat
  - get it working with default.nix and shell.nix
  - for old nix version support
  - eg https://github.com/thiagokokada/nix-alien/blob/master/compat.nix
- [x] devshell
  - treefmt, dprint, nixfmt-rfc-style
- [ ] extraoptions, username, email, hostname etc. global
- [ ] modular restructuring
  - allows enabling disabling things
  - hardware-configuration.nix needs to be untouched
  - [ ] disko
  - [ ] binfmt etc can be in different files

#### iron arch

- [ ] hm
- [ ] sysm

### vps (stand-in for non-nixos)

- [ ] hm
  - [ ] caddy?
- [ ] sysm
  - [x] syncplay
  - [ ] caddy
  - [ ] nix-serve ++ attic ++ harmonia
  - [ ] headscale ++ headscale-ui ++ tailscaled
  - [ ] rustdesk-server
  - [ ] serf? or headscale enough?

### per project

- [x] system is a project as well but track it above
- [ ] shell.nix
  - xc, treefmt, navi (,fzf, lazygit - global?)
  - move away from xc? taskfile, justfile, makefile, magefile, navi
- [ ] devenv services

### automatons

- [ ] Tailscale
  - Headscale or ui auto approve (device)
  - gotify or ntfy.sh approve?
  - [ ] tailscaled, ephemeral autologin
  - sysm or nixos depending on host

#### gha

- [ ] gha steps
  - disable hardware-configuration.nix before building?
  - have a full build action which does not use cache
    - or in a different repo? but can 10GB hold it
    - iron hm seems to be 7GB (nix-tree)
  - [ ] gha runner home-manager profile
  - [ ] repo/cache per host?
  - [ ] detect files changed and do only nixos or hm build to not waste gha resources
  - [ ] pre-commit hooks and pre-commit hooks step in gha like npins
    - nix fmt
    - flake checks etc in precommithooks
    - detect if non code change and append [skip ci] to commit msg
    - https://github.com/K900/vscode-remote-workaround/blob/main/flake.nix
- [ ] selfhosted
  - nixos
  - sysm
  - docker?
- [ ] gha config
  - hm (when using debug time action either upterm or cloudflared tunnel)
  - sysm
  - [ ] cloudflared service
    - for quick debugs
  - [ ] nix-serve, nix-serve-ng
  - [ ] serf?

#### forgejo-runners

- [ ] self hosted forgejo
- [ ] self host runners
- [ ] mirror repos from gh to forgejo
- [ ] multiuser setup

#### drone/concourse/etc.

- [ ] hmm

#### hydra

- tried but failed to run properly
- push to attic?

#### buildbot

- [ ] see numtide repos and how they do it

#### selfhosted binary caches

- [ ] installer iso two variations
  - One with my full setup
  - Other is minimal, absolutely necessary steps only
  - https://github.com/nix-community/nixos-generators
- [x] Nixos specialisations/systemd profiles idea
  - multiple generations which each act as a profile
  - generations can be named I watched this on a youtube video
  - It is nix specialisations
  - [x] mingetty/tty only specilization to act as a server
    - Ideally can be used if I learn to work without a mouse
    - Full nvim
    - [ ] TODO disable audio, printing etc, non-server things
  - [x] ly in a specialisation
    - ly flake config from https://github.com/NixOS/nixpkgs/pull/297434
    - [ ] make default after merged into unstable, remove my own fork as dependency
- [ ] Nixvim - neovim
- [ ] home-manager services
  - [x] espanso
- [ ] jupyenv/jupyterhub/jupyterlab
  - [ ] hm/sys service based on if hub/lab/single instance
  - [ ] project level config flake templates
- [ ] flakes modular
  - flake-parts
  - snowfalllib (meh, completely changes everything)
- [ ] Wayland external monitor sleeping bug workaround
  - New user works but need to somehow make /home/rithvij move to the new user
  - I did remove .cache didn't help, tried using default vals for all configs of plamsa
    didn't help
  - so the bug is hard to track down given I know nothing about plasma
- [x] Separate home-manager to work on non-nixos
  - [ ] TODO test on old manjaro this config

- [ ] tailscale on local instead of vps
  - also vps configuration in nix/dockerfiles separate repo?
  - rustdesk-server, syncplay, tailscale, headscale

- [ ] ragenix/sops-nix/rage
  - there is a awesome-age repo
  - yubikey try
  - Espanso module for this, copy pasting secrets
- [ ] nix-serve/harmonica
- [ ] Appimages and all github repos mirror
- [ ] Docker containers registry mirrors
- [ ] Experimental nix overlay store
  - Combine 2 nix stores
- [ ] Stylix
  - pywal like thing
- [ ] NixNG
  - For creating Containers
- [ ] Styx
  - binary cache substitutor something novel
- [ ] nix-serve ++ attic ++ harmonia
- [ ] gha backed magic cache
  - https://github.com/alexellis/actions-batch
  - https://github.com/fawazahmed0/action-debug
  - https://github.com/phanirithvij/debug-action

## termux/android

- [ ] nix-on-droid
  - two identical?
  - [ ] remote build on linux
  - [ ] distributed builds on both devices
  - proot is unusably slow

## non nix nix

- [ ] Ansible playbooks??
  - Not related to nix
  - Mainly for installing nix on vps
  - Same purpose as gha action yml
  - And Termux ofc, not possible to use nix

## nixpkgs+external+contribs

- [ ] https://elatov.github.io/2022/01/building-a-nix-package
  - add distrobox-tui, gh-i
  - add self as maintainer
  - https://sandervanderburg.blogspot.com/2014/07/managing-private-nix-packages-outside.html
  - https://sandervanderburg.blogspot.com/2012/11/an-alternative-explaination-of-nix.html
  - https://github.com/DeterminateSystems/update-flake-lock
- [ ] Teldrive
  - on vps and local (i.e system-manager module and nixos module, services)
  - maintainer on nixpkgs it's not there
  - Fork and add drag drop, existing listings, remember upload location and send pr for 1, 3
  - htmx rewrite fork, already in go
  - flake/npins setup
- [ ] cloudflared tunnel nixos service
  - multiple service (redis like)
  - write endpoint to /run/secrets or something so others can use it
