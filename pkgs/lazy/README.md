## TODO

need to figure out a way to make nix-store --realise drvPath work

- one way is to ensure we use gha to push the lazy .drv files to cache?
- other way is somehow retain the .drv (not via keep-derivations or something)
  but propagatedBuildInputs like
