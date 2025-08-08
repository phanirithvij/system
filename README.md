![repo size](https://img.shields.io/github/repo-size/phanirithvij/system)

## my system

## Details

- single nixos host, dedicated home-manager(hm) config
  - non-nixos hm config (old and outdated)
- rescue nixos iso host and hm config
- gha runner hm and system-manager(sysm) config
  - inprog macos hm
- vps sysm and hm config
  - vps outdated
- nix-on-droid + hm config
- packages
  - nixos-unstable always
  - few wrapper-manager managed pkgs
    - inprog mpv
  - nur-packages repo but not in nur-community
- specialisations (DE testing mainly)
  - kde (default, no specialisation, bloat but works)
  - xfce (slim, current daily driver, TODO new ver, experimental wayland)
  - niri (xwayland-sattelite, steam not working)
  - tty (for *serve profiles)
  - hyprland (meh drop later)
  - cinnamon (meh drop later)

## TODO

- [ ] move to selfhosted forgejo and mirror to gh
  - [ ] forgejo runners (selfhosted)
  - [ ] cron mirror git command
  - [ ] push on every commit
- [x] gha
- [ ] gitlab, cirrus ci, bitbucket pipeline setups
- profiles
  - mediaseve, mediaclient
  - gamesserve, gamesclient
  - nixserve

## Tasks

### switch

requires: home-switch, os-switch RunDeps: async

### os-boot

```
nh os boot .
```

### os-test

```
nh os test .
```

### os-switch

```
nh os switch .
```

### home-switch

```
nh home switch . -b bak -c rithvij@iron
```

### home-switch-specialisation

```
$(nom build .#homeConfigurations."$USER@$HOSTNAME".activationPackage --no-link --print-out-paths)/specialisation/xfce/activate
```

### flkupdcmt

```
nix flake update --commit-lock-file
```

### iso-build

```
nom build .#nixosConfigurations.defaultIso.config.system.build.isoImage --no-link
```

### home-build

```
nom build .#homeConfigurations."rithvij@iron".activationPackage --no-link
nh home build .
```

### os-build

```
nixos-rebuild build --flake .#iron
nom build .#nixosConfigurations.iron.config.system.build.toplevel --no-link
nh os build . -H iron
```

### nix-on-droid

```
nom build .#nixOnDroidConfigurations.default.activationPackage --impure
```

### prune

```
nh clean all --nogcroots
sudo nix-collect-garbage -d
```

### nix-olde

```
nix run github:trofi/nix-olde -- -f ".#iron"
nix run github:trofi/nix-olde -- -f ".#defaultIso"
```
