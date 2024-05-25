# system
main system configuration including dotfiles, will recreate repo with private dotfiles removed and then make it public

## TODO
- [ ] installer iso two variations
    - One with my full setup
    - Other is minimal, absolutely necessary steps only
    - https://github.com/nix-community/nixos-generators
- [ ] try ly flake config from https://github.com/NixOS/nixpkgs/pull/297434
- [ ] mingetty/tty only specilization to act as a server
    - Ideally can be used if I learn to work without a mouse
    - Full nvim
- [ ] Nixvim - neovim
- [ ] home-manager services
- [ ] devenv services
    - per project
- [ ] extraoptions, username, email, hostname etc. global
- [ ] modular restructuring
    - allows enabling disabling things
    - hardware-configuration.nix needs to be untouched
    - [ ] disko
    - [ ] binfmt etc can be in different files
    - flake schemas is a new halted rfc because of the Elco
- [ ] systemd profiles
    - multiple generations which each act as a profile
    - generations can be named I watched this on a youtube video
        - find that link?
- [ ] jupyenv/jupyterhub/jupyterlab
- [ ] flake compat, working with default.nix and shell.nix
- [ ] flake templates, need to learn
- [ ] Wayland external monitor sleeping bug workaround
    - New user works but need to somehow make /home/rithvij move to the new user
    - I did remove .cache didn't help, tried using default vals for all configs of plamsa
        didn't help
    - so the bug is hard to track down given I know nothing about plasma
- [ ] Separate home-manager to work on non-nixos
- [ ] initial installation setup for nixos and non-nixos linux
    - Scripts and writeups
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
    - rustdesk, syncplay, tailscale
- [ ] All these useful nix commands in navi/tmuxp/dmux/espanso/jupntbks/mprocs
    - Also nh tool is useful
        - comes with nom, nvd integration
    - hm switch
    - nixos switch
    - nix profile
    - nix-shell, nix shell
    - nix-shell with python jupyerlab
    - detsys nix install script
- [ ] ragenix/sops-nix
    - yubikey try
    - Espanso module for this, copy pasting secrets
- [ ] nix-serve/harmonica
- [ ] Appimages and all github repos mirror
- [ ] Docker containers registry mirrors
- [ ] Experimental nix overlay store
    - Combine 2 nix stores
- [ ] Styx
- [ ] NixNG
    - For creating Containers

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
    - Again at the mercy of the Elco
- cppnix meson refactor blocked by the Elco, would make it easy to compile it seems with the only con of having python as a build dep but that's ok.
- nix upgrade-nix blocked by the Elco in favor of detsys/nix-installer
- nix portable exists which installs nix without sudo
    - would've been very useful when I was in uni with sudo disabled

