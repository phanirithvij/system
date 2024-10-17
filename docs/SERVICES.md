## TODO

A selfhosted heaven all in nixos

- [ ] Immich
  - https://github.com/NixOS/nixpkgs/pull/324127
- [ ] Email server
- [x] Syncplay
  - Runs, tested once
- [x] Jellyfin
- [ ] Caddy
- [ ] Teldrive
  - I need to make it
- [ ] pyload
- [ ] archivebox
- [ ] android-file-transfer automount
  - disable kio kde thing
  - found https://bbs.archlinux.org/viewtopic.php?pid=1944871#p1944871
  - I need to make it
  - Is it worth it for ~12MiBps extra?
- [ ] Wikipedia
- [ ] kiwi
- [ ] searxng
- [ ] Oodoo corporate
  - nix-build -E 'with import <nixpkgs> {}; nixosTests.odoo' --check --no-out-link
  - nixosTests.odoo15 and odoo16 are all failing
- [x] your_spotify
  - customised to have SPOTIFY_CLIENT_ID to be secret too
- [ ] buildbot-nix
  - CI w/ python

- Nix specific
- [x] pr-tracker
  - [ ] https://github.com/matt1432/pr-tracker/issues/1
- [x] better pr-tracker
  - nixpkgs-tracker
- [x] nixos landscape
  - always facing SSL errors
  - cafkafk is busy with non-nix things
- [ ] home-manager-option-search
- [ ] nixos-search
- [ ] old versions tracker
- [ ] ofborg (necessary?)
  - https://github.com/NixOS/ofborg/wiki/Operating-a-Builder/
- [ ] docs (all)
  - https://github.com/phanirithvij/mmdoc-nixpkgs-toc-gen.git

- pdf and docs tools
  - s-pdf (striling-pdf)
  - https://sioyek-documentation.readthedocs.io/en/latest/configuration.html
  - w3mman (key : for loading urls in manpages)
  - pinfo is bad (see pinfo lf)

Another doc for selfhosted docker/podman stuff

- using all of these via docker compose
- [ ] Immich
- [ ] Teldrive
  - have own repo with docker-compose config
  - [ ] todo document it
- [ ] postgres backups
- [ ] vnstat-docker

- All the above services
  - just in case I leave nixos due to the toxicity
