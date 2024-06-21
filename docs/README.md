# system

main system configuration including dotfiles, will recreate repo with private dotfiles removed and then make it public

## TODO

- [ ] modules, profiles, applications
  - see https://github.com/Guanran928/flake
  - allows others to import?
- [ ] home-manager for different hosts
  - shared /nix partition r/w?
    - garbage collection might get fked
      - gha cache to the rescue?
    - use ext drive as backup nix store and nix-serve it when detected?
      and use as another trusted substitutor?
      - and never gc it?
      - makes no sense, substitutor won't solve the space issue
        - nfs mount?
- [ ] shell.nix
  - xc, dprint, navi, fzf, lazygit
  - move away from xc? taskfile, justfile, makefile, magefile, navi
- [ ] gha steps
  - disable hardware-configuration.nix before building?
  - caching limit needs to be taken into consideration
    - disable qbittorrent, firefox, large packages
    - minecraft (prismlauncher, steam-run)
    - linux kernel takes some time
    - also non-free pkgs
    - or simply anything not caches by cache.nixos.org?
    - [ ] gui profile? disable when running gha?
  - or have a full build action which does not use cache
    - or in a different repo? but can 10GB hold it
    - iron hm seems to be 7GB
  - whacky
    - [ ] gha runner home-manager profile
    - [ ] repo/cache per host?
  - [ ] detect files changed and do only nixos or hm build to not waste gha resources
  - [ ] pre-commit hooks and pre-commit hooks step in gha like npins
    - xc fmt
    - detect if non code change and append [skip ci] to commit msg
    - https://github.com/K900/vscode-remote-workaround/blob/main/flake.nix
  - [ ] remove xc? somehow get navi cheats to work via cli without duplication
    - nix attrsets for commands and converted to navi, espanso, etc? or ref by id/slug each command?
    - or just yaml -> json -> nix lib.importJSON/builtins.fromJson
      - builtins.fromyaml non-existent, there's an open pr NixOS/nix#7340
    - raw text for cheats, etc
- [ ] minimal profile
  - remove alsa, 32bit
  - documentation enable false
  - man pages
- [ ] mouse heavy wf
  - awesomewm
  - dunst
- [ ] buku
  - webserver as nixos module?
- [ ] espanso (outside shell or when navi is not enough)
  - buku so I can not have a flocuss folder incident
  - navi so I can paste navi commands online?
  - authpass so I can paste passwds online
  - gopass + lesspass (gopass-hibp?)
  - whacky: gopass totp, gopass reads .kdbx?
  - sops secrets, age? o.O
- [x] formatter is nixfmt-rfc-style
  - dprint for other things
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
  - [ ] ly in a specialisation
    - ly flake config from https://github.com/NixOS/nixpkgs/pull/297434
- [ ] Nixvim - neovim
- [ ] home-manager services
  - [x] espanso
- [ ] devenv services
  - per project
- [ ] extraoptions, username, email, hostname etc. global
- [ ] modular restructuring
  - allows enabling disabling things
  - hardware-configuration.nix needs to be untouched
  - [ ] disko
  - [ ] binfmt etc can be in different files
  - flake schemas is a new halted rfc because of the Eelco
- [ ] jupyenv/jupyterhub/jupyterlab
  - [ ] hm/sys service based on if hub/lab/single instance
  - [ ] project level config flake templates
- [ ] flake compat
  - get it working with default.nix and shell.nix
  - for old nix version support
  - eg https://github.com/thiagokokada/nix-alien/blob/master/compat.nix
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
- [ ] ssh keys, ssh certs
  - yubikey try
- [ ] tailscale on local instead of vps
  - also vps configuration in nix/dockerfiles separate repo?
  - rustdesk-server, syncplay, tailscale, headscale
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
- [ ] Attic
- [ ] Harmonia
- [ ] Nix-serve
- [ ] gha backed magic cache
  - https://github.com/alexellis/actions-batch
  - https://github.com/fawazahmed0/action-debug
  - https://github.com/phanirithvij/debug-action
  - [ ] Tailscale
    - Headscale auto approve (device)
- [ ] system-manager
  - https://github.com/numtide/system-manager
  - [ ] vps config
    - [x] init
    - hm
    - services:
      - [x] syncplay
      - [ ] nix-serve ++ attic ++ harmonia
      - [ ] headscale ++ tailscaled
      - [ ] rustdesk-server
  - [ ] gha config
    - [x] init
    - hm (when using debug time action either upterm or cloudflared tunnel)
    - [ ] cloudflared service
    - [ ] nix-serve
    - [ ]
- [ ] nix-on-droid
  - two identical?
  - [ ] remote build on linux
  - [ ] distributed builds on both devices
  - proot is unusably slow
- [ ] Ansible playbooks??
  - Not related to nix
  - Mainly for installing nix on vps
  - Same purpose as gha action yml
  - And Termux ofc, not possible to use nix

## TODO nixpkgs+external

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
- [ ] cloudflared tunnel nixos service
  - multiple service (redis like)
  - write endpoint to /run/secrets or something so others can use it

## NOTES

- home-manager manages itself for now in a single user env
  - Allows users to manage their own version
- in a multi-user scenario a single global home-manager can be enabled in the flake modules
  ```nix
  nixosConfigurations = {
    iron = nixpkgs.lib.nixosSystem {
      modules = [
        {
          environment.systemPackages = [
            home-manager.packages.${system}.default
          ];
        }
      ];
    };
  };
  ```
- nix flake show can be used with `| less`
  - for home-manager it crashes (too big?)
- nix schema supported nix can be installed form detsys's nix fork with schema support
  - Again at the mercy of the Eelco
- cppnix meson refactor blocked by the Eelco, would make it easy to compile it seems with the only con of having python as a build dep but that's ok.
- nix upgrade-nix blocked by the Eelco in favor of detsys/nix-installer
- nix portable exists which installs nix without sudo
  - would've been very useful when I was in uni with sudo disabled
