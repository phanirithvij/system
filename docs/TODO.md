# system

main system configuration including other whacky ideas
more are in my zet but that is to be made public

## TODO

### ideas

- [ ] matt1432
  - https://github.com/matt1432/nixos-configs
  - https://github.com/jorsn/flakegen
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
  - hyprland
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
    - a bit risky maybe, data loss?
  - [ ] binfmt etc can be in different files

#### DEs + rice

- [x] plasma6
  - [ ] plasma-manager (chris mcdonough vid)
- [ ] xfce
  - [ ] wayland (future)
- [ ] hyprland
- [ ] ratpoison
  - jake@linux videos
  - https://github.com/jdpedersen1/windowmanagers/tree/master
  - also his menu scripts which dropdown, they are beautiful
  - yank his void rice too
- [ ] awesome (one of my favs)
- [ ] dwm ?
  - suckless people were called neonazis before
  - also c configuration seems cool
  - maybe I can learn zig and package it via zig with nix
- [ ] xmonad
- [ ] qtile
- [x] gnome ??
  - seems going down the wrongpath TM
  - along with nixos, openSuse, redhat, firefox

- [ ] dunst
- [ ] rofi, wofi

#### iron arch

- [ ] hm
- [ ] sysm
- [ ] nix-free normal setup, incase nix goes to shit
- [ ] manjaro, garudalinux and endavour have some good scripts/configs
  - yank those

#### iron manjaro

- [ ] hm
- [ ] sysm
- [ ] todo move over to archlinux slowly, leave manjaro

### vps (stand-in for non-nixos)

- [ ] No longer have a vps, do it in a local vm/docker/manjaro/arch
- [ ] hm
  - [ ] caddy?
- [ ] sysm
  - [ ] syncplay
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
  - [ ] repo/cache per host?
  - [ ] detect files changed and do only nixos or hm build to not waste gha resources
- [ ] selfhosted
  - nixos
  - sysm
  - docker?
- [ ] gha config
  - [ ] cloudflared service
    - for quick debugs
  - [ ] nix-serve, nix-serve-ng, attic
  - [ ] serf?
  - [x] tailscale ephemeral
    - [ ] headscale ephemeral

#### forgejo-runners

- [ ] self hosted forgejo
- [ ] self host runners
- [ ] mirror repos from gh to forgejo
- [ ] multiuser setup

#### woodpecker/concourse/etc.

- [ ] hmm
- [ ] argo cd
- [ ] jenkins
- [ ] gocd

#### hydra

- tried but failed to run properly
- push to attic?

#### buildbot

- [ ] see numtide repos and how they do it

#### uncategorized

- [ ] selfhosted binary caches
- [ ] installer iso two variations
  - One with my full setup
  - Other is minimal, absolutely necessary steps only
  - https://github.com/nix-community/nixos-generators
- nix specialisations
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
- [x] KDE plasma external monitor sleeping bug workaround
  - new user works but need to somehow make /home/rithvij move to the new user
  - I did remove .cache didn't help, tried using default vals for all configs of plamsa
    didn't help
  - so the bug is hard to track down given I know nothing about plasma
  - works fine in hyprland

- [ ] headscale on local instead of vps
  - also vps configuration in nix/dockerfiles separate repo?
  - rustdesk-server, syncplay, tailscale, headscale
  - [ ] wait for fiber connection

- [ ] ragenix/sops-nix/rage
  - there is a awesome-age repo
  - yubikey try
  - Espanso module for this, copy pasting secrets
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
- [ ] gha backed on demand remote builders
  - https://github.com/alexellis/actions-batch
  - https://github.com/fawazahmed0/action-debug
  - https://github.com/phanirithvij/debug-action

## termux/android

- [x] nix-on-droid
  - two identical?
  - [ ] remote build on linux
  - [ ] distributed builds on both devices
  - proot is unusably slow

## non nix

- [x] for nix: detsys installer for gha/vps
- [ ] Ansible playbooks
  - _Not related to nix_ !!!
  - Termux, not possible to use nix (nod proot slow alternative)

## nixpkgs+external+contribs

- https://sandervanderburg.blogspot.com/2014/07/managing-private-nix-packages-outside.html
  - https://sandervanderburg.blogspot.com/2012/11/an-alternative-explaination-of-nix.html
  - https://github.com/DeterminateSystems/update-flake-lock
- [ ] teldrive
  - flake/npins setup
  - on vps and local (i.e system-manager module and nixos module, services)
  - become maintainer on nixpkgs since it isn't there
  - [ ] fork
    - ui drag drop
    - remember upload location
    - [ ] and send pr upstream
    - own fork:
      - existing listings
      - htmx rewrite, already in go
- [ ] cloudflared tunnel nixos service
  - multiple service (redis like)
  - write the output endpoints to /run/secrets
    or somewhere other processes can read from
- [ ] trash-cli, trashy, fzf, lf
  - tui?
- [ ] pr-tracker prs
  - http://localhost:8000/pr-tracker?pr=328862 - rustdesk headless client service
  - http://localhost:8000/pr-tracker?pr=323381 - quickgui
