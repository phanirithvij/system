# notes to self

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
- nix portable exists which installs nix without sudo
  - would've been very useful when I was in uni with sudo disabled
- formatter is nixfmt-rfc-style
  - treefmt+dprint for other things

# nixey by other people

Useful links along with my annotations.

- [ ] Leaving as todos for I must replace with links

## Configs

- see my github stars list https://github.com/stars/phanirithvij/lists/nixosothersdotfiles
- https://github.com/gvolpe/nix-config
  - nix flakes schema overlay
- https://github.com/workflow/dotfiles
  - gha initial setup
-

## Notes

- https://github.com/nikitavoloboev/knowledge/blob/main/docs/package-managers/nix/nix.md
- https://github.com/kitnil/notes/blob/master/nix.org
- https://github.com/Anton-Latukha/nix-notes/blob/master/nix.org
- https://github.com/drakerossman/nixos-musings
  - https://drakerossman.com/blog

## Blogs

- https://jade.fyi/blog/flakes-arent-real/
  - convinced me to use flakes only if necessary, I decided to go on with flakes
  - also plan to try npins and if I can get it working stay there
  - flake inputs are inflexible
    - https://github.com/NixOS/nix/issues/3966
    - https://github.com/jorsn/flakegen
  - flake schemas
    - https://github.com/gvolpe/nix-config
  - cli stablilisation
  - lazy trees
  - many such incomplete things
  - https://github.com/andir/npins
  - https://github.com/privatevoid-net/nix-super
- https://github.com/nixlang-wiki/nixlang-wiki/tree/main/nix
-

## Useful projects (I use)

- List only stuff I use! see awesome-nix for all other things
- https://github.com/numtide/system-manager
  - bring nixos to non-nixos dyi kinda, alpha
  - https://github.com/a-h/system-manager-test/tree/main
  - https://github.com/a-h/nix-airgapped-vm
- [ ] nix-olde, nix-du, nix-inspect, nix-tree etc
- [ ] nom, nh, nvd
- [ ] hm
- [ ] direnv
- [ ] nixos-infect

## Discourse/gh prs/gh issues

## Technical

### blocked/halted

- lazy trees - only helps with local flakes, shallow clones or github:x/x can't utilise it
- flake schemas - useful for flake checks it seems
- cppnix meson refactor blocked, would make it easy to compile it seems with the only con of having python as a build dep but that's ok.
- nix upgrade-nix blocked in favor of detsys/nix-installer

### beginner

- overlay
- cargo sha256 workaround
- python packageswith syntax

## Meta

### important underlying issues (reddit term is drama)

- eelco tech decisions
- flakes
- flakes merged (experimental)
- flakehub
- detsys grahamc flakes are stable post
  - _no_

- srid permaban
  - red meat + woke critisism

- jonringer audril MIC post
  - community divide
  - open letter for eeclo to step down
  - detsys blogpost eelco without permission
    - corporate speak
    - asks users to move communities (i am inclined to)
- jonringer tempban
- youtuber tempban, shea levy tempban
  - over nazisim semantics discussion with nat418

- ratioberatus quit, lix
  - nix update mic92, no proper stable upgrade process
- jonringer commit bits
  - anticipates backlash, gets backlash
    - "lies" about timeline
    - walks back and apologises (no one cares)
  - samueldr ragequit nixos mobile abdandon
  - xe ragequit
- jonringer permaban
  - jonringer steps down from discord and reddit

### awesome

- year in nix
- reproducible
- nix cli stabilisation
- flakes stabilisation
