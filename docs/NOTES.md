## notes to self

- xargs -I {} will work with -d' ' only (bash)

- home-manager manages itself for now in a single user env
  - Allows users to manage their own version
- in a multi-user scenario a single global home-manager can be enabled in the
  flake modules
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
- nix schema supported nix can be installed form detsys's nix fork with schema
  support
- nix portable exists which installs nix without sudo
  - would've been very useful when I was in uni with sudo disabled
- formatter is nixfmt-rfc-style
  - treefmt+dprint for other things
- dprint broken with treefmt-nix need to file an issue TODO
- git-repo-manager for git repos own and others and symlink to appropriate
  locations
  - eg. for go projects etc. ~/Projects/go
  - zig -> ~/Projects/zig
  - system -> ~/Projects/system -> ~/Projects/\!Own/system
- nix bundle works but initial startup is slow
- nix bundle ralismarks/nix-appimage doesn't work on non-nix system
  - tried on one for navi and firefox
- home-manager has specialisations as well like nixos.
  - [ ] I need to try it out.
- editor setup w/ lsp should be #1 priority for nix before writing/preusing
  non-trivial nix
  - noogle is very useful for jumping to stdlib src
  - nix pills is very very useful
  - nix.dev tuts
  - nix manual
  - nixos manual
  - nixpkgs manual
  - hm manual
- lychee for link checking, everywhere (has a gha, also nix lycheeCheck)
- override, overrideAttrs, overrideModAttrs
- applyPatches
  - if you import it then it is IFD
- experimental features + advanced features (TODO add links here)
- nixseparatedebuginfod
  - https://matrix.to/#/!kjdutkOsheZdjqYmqp:nixos.org/$IW0dpiyjyC5SD7w-nOFyaekzP3HP96XCvw6Lzfg47pM
- hand-rolled >> nix-update >> nix-prefetch
  - by-name manual migration comes with issues?
  - faced when writing opengist update script
  - https://matrix.to/#/!kjdutkOsheZdjqYmqp:nixos.org/$ChkVlbom95iNwaNoCBb0H0m4EpXoybi2H92X4EZvWJI
  - hm espanso
    https://matrix.to/#/!kjdutkOsheZdjqYmqp:nixos.org/$qPRxcb3wHaAN5cJJXCUUnCIrGv8wkGcax0bnaO_5HQo
- focaltech driver pr
  - makePkgconfigItem
    - https://github.com/NixOS/nixpkgs/pull/354311#discussion_r1835286178
- IFD is not simply `${drv}` but `import "${drv}"`
  - which is why cargo pacakges, yarn packages etc. have lockfiles in nixpkgs
  - because `${src}/Cargo.lock` will be imported by buildRustpackage etc.
- use fetchpatch2 whenever possible over fetchpatch, because fetchpatch is
  old/outdated, fetchpatch2 fixes issues
  - patches might not get applied correctly if using fetchpatch
  - also `?full_index=1` for patch urls for github patches for reproducibility.
- requireFile
  - non-redistributable files user warning with file hash verified
  - also can write an fixed output derivation maybe a python script which
    downloads the files,
    https://nix.dev/manual/nix/stable/glossary#gloss-fixed-output-derivation
- git bisect with nixos-rebuild vm (nix-hour #8 18:20)
  - `nix-build <nixpkgs/nixos> --arg configuration ./configuration.nix -A vm`
  - `nix-build ./nixos --arg configuration ./configuration.nix -A vm`
  - echo $LINES $COLUMNS (outside vm) (nhr#8 32:28)
  - stty rows 28 cols 128 (resize vm console area)
- git bisect run "command"
- `nix-build -A something --arg config '{ allowUnfree = true; }'` (nix-hour #8
  33:48)
  - argstr
  - arg is for nixpkgs
  - nix-instantiate -A same as above
    - stops before build
- nix-build-uncached
  - What is it exactly?
- modulesPath is a flake compatible thing (nix-hour #8 20:05)
- just `nix-shell -p` gives patchelf, make etc. stdenv (nix-hour #8 29:15)
- previously mkShell couldn't be built then `inputDerviation` had to be used
  (nix-hour #11)
- __noChroot to escape sandbox if relaxed (nix-hour #12 29:30)
- buildEnv
  - pkgsPath passAsFile
- nix-locate, nix-index, nix-index-database, comma, command-not-found.dbPath,
  NIX_AUTO_RUN (nix-hour #63)
- `nix repl .`
- `nix repl .` in system flake and can do
  `nixosConfigurations.iron.config/options`
- `_module.args` (nix-hour #63 52:21 npins)
- [ ] make nix-hour into a blog
  - https://github.com/allrealmsoflife/nix-hour-transcripts
    - help out?
  - nix-hour repo has code samples for some (ep 24+)
  - huge undertaking
  - talk with infinisil
  - segments (if possible)
  - bits/clips/timestamped links in blog
  - navi cheats
  - https://github.com/tweag/nix-hour/issues?q=is%3Aissue+sort%3Areactions-%2B1-desc+
  - https://www.reddit.com/r/youtubedl/comments/1acz8lf/live_chat/
  - https://gist.github.com/pukkandan/ee737fec64822f2552caf3ca4cbf5db7
    - https://gist.github.com/tinyapps/df2b6757a142ff93caf9c63d0ef38b11
  - https://github.com/xenova/chat-downloader
  - https://github.com/sonigy/YCS/issues/58#issuecomment-2389179106
  - https://www.reddit.com/r/youtubedl/comments/15fcrmd/transcript_extract_from_youtube_videos_ytdlp/
  - https://github.com/yt-dlp/yt-dlp/issues/7496
- 2025-08-10T12:41, had to do
  `sudo btrfs rescue zero-log /dev/disk/by-label/nixroot` from live iso to be
  able to boot into linux, common issue
  https://www.phoronix.com/news/Btrfs-Log-Tree-Corruption-Fix

### Ramblings or thoughts

- If I don't need pure evaluation then flake-compat is good enough?
  - Does it mean pure evaluation is useful or not?
  - from my impression pure eval is great since you need to explicitly define
    everything
  - but flake-compat disallows it? I think the default behavior of nix-* vs nix
    cli has changed that's all?
  - so with old cli we need to do --pure and with new we need --impure?
- Can I migrate to npins?
  - all this drama about how flakes are not that good is irritating and
    influencing me to avoid them.
  - but npins might not satisfy every need I have, since there are flakes which
    I depend on as of now.
  - multiple instances of nixpkgs, and patching nixpkgs can be done without
    flakes
  - niri cannot be used without flakes as of now (since it is not in nixpkgs?)
    (verify this) (I can give it up)
    - I will use niri when I can use it withou a touchpad?
    - but I like the touchpad scroll
  - hyprland flake too (I can give it up) (it is in hm and nixpkgs if needed)
  - flake-schemas, it can be its own project(directory), I don't need it in my
    nixos config really
    - [x] builtins.getFlake and threw in in nurpkgs, so it is in cachix
  - crane, etc not needed
  - [x] blobdrop -> nixpkgs per my package request (done in my config)
- TODO maintain own npins channels
  - since channels are minimal compared to github repo size
  - but channels can be generated on my own via local checkout of nixpkgs
  - no need for a network roundtrip
  - do something like what nixpkgs-review does and have a worktree and checkout
    the specific command and run the command to generate a channel.
    - channels are good but treeshaking or something to remove dead nix code
      based on input nix expression would be better
      - https://matrix.to/#/!kjdutkOsheZdjqYmqp:nixos.org/$KLCWy-2ZeuxKYxLUFHYI2otJnWXnqA7vrx5i5bI95bE
    - eg. given a nix file, strip stuff from nixpkgs until the derivation
      "output" changes compared to full nixpkgs. (hash will change obviously)
      - ca derivations?
      - lazy trees?

# nixey by other people

Useful links along with my annotations.

- [ ] Leaving as todos for I must replace with links

## Configs

- see my github stars list
  https://github.com/stars/phanirithvij/lists/nixosothersdotfiles
  - I star every nixos config I encounter (this is not good)
- https://github.com/gvolpe/nix-config
  - nix flakes schema overlay
- https://github.com/workflow/dotfiles
  - gha initial setup inspired by this
- TODO document where I yanked what from
- TODO yank wsl setup form
  https://github.com/grig-iv/nix-config/blob/main/home-manager/grig%40work-wsl.nix
  - TODO yank repo cloning setup from the same
  - TODO what I though git-repo-manager was. make it work. also git-prole
    declerative
- [ ] postgresql backup with rustic
- [ ] impermanence
  - not worth the effort imo
  - since it has the potential for data loss
  - but sounds good in theory (declarative folder allowlist)

## Notes

- https://github.com/past-nikiv/knowledge/blob/main/docs/package-managers/nix/nix.md
- https://github.com/kitnil/notes/blob/master/nix.org
- https://github.com/Anton-Latukha/nix-notes/blob/master/nix.org
- https://github.com/drakerossman/nixos-musings
  - https://drakerossman.com/blog
- https://github.com/mcdonc/.nixconfig/blob/master/videos/tipsntricks/script.rst

## Blogs

- https://jade.fyi/blog/flakes-arent-real/
  - convinced me to use flakes only if necessary, I decided to go on with flakes
    for my system config
  - also plan to try npins and if I can get it working stay there
    - upd: npins for simple projects with few inputs, flakes if they provide
      quality flakes w/ tons of stuff
  - flake inputs are inflexible
    - https://github.com/NixOS/nix/issues/3966
    - https://github.com/jorsn/flakegen
    - upd: imo not worth it to break up flake inputs
      - https://github.com/matt1432/nixos-configs/issues/1
  - flake schemas
    - https://github.com/gvolpe/nix-config
  - cli stablilisation
  - lazy trees
  - many such incomplete things
  - https://github.com/andir/npins
  - https://github.com/privatevoid-net/nix-super
- https://github.com/nixlang-wiki/nixlang-wiki/tree/main/nix
- https://ayats.org/blog
- full time nix pod
- nixpkgs.news (dead since 3 months)
- https://ianthehenry.com/posts/how-to-learn-nix/
- https://vereis.com/posts/nixos_kool_aid

## Useful projects (I use)

- List only stuff I use! see awesome-nix for all other things
- https://github.com/numtide/system-manager
  - bring nixos to non-nixos dyi kinda, alpha
  - https://github.com/a-h/system-manager-test/tree/main
  - https://github.com/a-h/nix-airgapped-vm
- nom >> nh > nvd (utility)
- https://github.com/nix-community/home-manager
  - https://home-manager-options.extranix.com/
- direnv
  - use flake in envrc
- [ ] nix-olde, nix-du, nix-inspect, nix-tree, nix-top, nix-melt, nix-init etc
- [ ] nixos-infect ?? nixos-anywhere
- [ ] xc/just
  - meh never used them
  - might just go with navi & espanso (project level)
  - project level atuin? (all this rust is unnecessary)
- [ ] nixci
  - [ ] omnix
- [ ] attic, harmonia, nix-serve, nix-serve-ng
- https://github.com/hakoerber/git-repo-manager
  - I assumed this will keep repos in sync
  - but I have to use it to write scripts to do it?
- nmt + nmd (sr.ht/~rycee)
  - tests and docs for hm

## Discourse/gh prs/gh issues

## Technical

### blocked/halted/stale

- lazy trees - only helps with local flakes, shallow clones or github:x/x can't
  utilise it
- flake schemas - useful for flake checks it seems
- nix upgrade-nix blocked in favor of detsys/nix-installer
- ca-derviations (halted due to lack of funds, my best guess)
- recursive-nix (poor discoverability)

### beginner

- overlays (overlay module)
- cargo sha256 workaround
- python packageswith syntax vs python3xxPackages.pkg
- nix-prefetch-scripts (nix-prefetch-url/git/github)
  - nix-prefetch has an advanced cli (-A or something) FIND it

## Meta

### important underlying issues (reddit term is drama)

- eelco tech decisions
- flakes
- flakes merged (experimental)
- flakehub
- detsys grahamc flakes are stable post
- detsys nix distribution
  - seo paid adverts

- srid permaban

- polls
  - https://pol.is/4uh6xvah6b
  - https://pol.is/report/r4zurrpweay6khmsaab4e

- jonringer audril MIC post
  - community divide
  - open letter for eeclo to step down
  - detsys blogpost eelco without permission
    - corporate speak
    - asks users to move communities
- jonringer tempban
- youtuber chirsmcdonough tempban, shea levy tempban
  - over semantics discussion with nat418

- ratioberatus quit, lix
  - nix version updated by mic92, no proper stable upgrade process
    - [x] fixed likely as they have extensive tests after this incident
- jonringer commit bits
  - anticipates backlash, gets backlash
    - "lies" about timeline
    - walks back and apologises (no one cares)
  - samueldr ragequit - nixos mobile abdandon
  - xe quit
- jonringer permaban
  - jonringer steps down from discord and reddit
  - jonringer doesn't step down from reddit (poly-repo fork)
  - jonringer nix podcast episode
  - jonringer ekala

### awesome

- year in nix
- reproducible
- nix cli stabilisation
- flakes stabilisation
- this month in documentation

### Other

- my utility projects
  - npins templates
  - nix-shell-templates
  - flake-templates (maybe same as above)
    - use flake template feature for nix-shell-templates too? but make it work
      with old nix-* commands
  - npins > flake-compat
