## TODO

need to figure out a way to make nix-store --realise drvPath work

- one way is to ensure we use gha to push the lazy .drv files to cache?
- other way is somehow retain the .drv (not via keep-derivations or something)
  but propagatedBuildInputs like
- maybe we dave a dedicated gc roots
- maybe we have a fake package/folder in the nix store which stores all the .drv
  files inside the subfolder so that nix won't consider them actual derviation
  files tied to any particular derviation and allow us to treat them as regular
  files.
  - but in this case, do we need to save the input drvs etc.. i.e. the whole
    tree
- [ ] nom progress for first initialisation
- [ ] TODO move to lazy apps
  - vliv
  - [x] heroic
    - [ ] electron (parent, lazy this if possible)
  - jampack
  - deno
    - nvf (parent, don't mklazy this)
- some of these might require them to be be cachix or some custom gc root logic
