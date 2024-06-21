## my system

## TODO

- [ ] move to selfhosted forgejo and mirror to gh
  - [ ] forgejo runners (selfhosted)
  - [ ] cron mirror git command
  - [ ] push on every commit
- [x] gha
- [ ] gitlab, cirrus ci, bitbucket pipeline setups

## Tasks

### switch

requires: home-switch, os-switch
RunDeps: async

### os-boot

```
nh os boot .
```

### os-switch

```
nh os switch .
```

### home-switch

```
nh home switch . -b bak -c rithvij@iron
```

### flkupdcmt

```
nix flake update --commit-lock-file
```

### iso-build

```
nom build .#nixosConfigurations.defaultIso.config.system.build.isoImage
```

### home-build

```
nom build .#homeConfigurations."rithvij@iron".activationPackage
nh home build .
```

### os-build

```
nixos-rebuild build --flake .#iron
nom build .#nixosConfigurations.iron.config.system.build.toplevel
nh os build . -H iron
```

### nix-on-droid

```
nom build .#nixOnDroidConfigurations.default.activationPackage --impure
```

### prune

```
sudo nix-collect-garbage -d
```

### nix-olde

```
nix run github:trofi/nix-olde -- -f ".#iron"
nix run github:trofi/nix-olde -- -f ".#defaultIso"
```
