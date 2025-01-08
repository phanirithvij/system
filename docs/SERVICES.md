## TODO

A selfhosted heaven all in nixos
Make sure all these run with system-manager + home-manager setup

- [ ] silverbullet.md (in nixpkgs)
- [ ] Immich
  - https://github.com/NixOS/nixpkgs/pull/324127
- [ ] Email server
  - not worth it is the online consensus
  - but worth it as a learning experience
  - https://gitlab.com/simple-nixos-mailserver/nixos-mailserver
    - https://nixos-mailserver.readthedocs.io/en/latest/setup-guide.html
- [x] Syncplay
  - Runs, tested once
- [x] Jellyfin
  - [ ] one pace agent
- [x] plex
  - with hama, one pace agents
- [ ] Caddy
  - with extensions (available in nixpkgs)
- [ ] Teldrive (own nur)
  - [ ] rclone
- [ ] chihaya (own nur)
  - maybe upstream
- [ ] pyload (available)
- [ ] archivebox (WIP https://github.com/NixOS/nixpkgs/pull/354836)
- [ ] android-file-transfer automount
  - disable kio kde thing
  - found https://bbs.archlinux.org/viewtopic.php?pid=1944871#p1944871
  - I need to make it
  - Is it worth it for ~12MiBps extra?
  - fuse + wifi transfer from android devices
- [ ] kiwix
  - [ ] Wikipedia backups
- [ ] searxng
- [ ] Odoo corporate
- [x] your_spotify
  - customised to have SPOTIFY_CLIENT_ID to be secret too
- [ ] buildbot-nix
  - CI w/ python
- [ ] opengist (WIP @me)
  - code snippets, other things
  - invidual + corporate instances (pub/priv/unlisted gists)
  - alt. tclip by tailscale, but I call that vendor lock-in
  - nixos module + sysm + data dir
  - restrict ssh, custom ssh/ui ports
- [ ] robherley/snips.sh
  - has tui :)
  - code snippets, other things
  - invidual + corporate instances (pub/priv/unlisted gists)
  - nixos module + sysm + data dir
  - restrict ssh, custom ssh/ui ports
- [ ] qbittorrent server
  - with scripts (ntfy, gotify)
  - reddit.com/r/qBittorrent/comments/vyt1sz/comment/lpgxc2c
  - qbittorrentui (own nur)
  - https://github.com/qbittorrent/qBittorrent/wiki/Running-qBittorrent-without-X-server-(WebUI-only,-systemd-service-set-up,-Ubuntu-15.04-or-newer)
    - qbittorrent-nox (WIP https://github.com/NixOS/nixpkgs/pull/287923)
- [ ] restic/borg (available)
  - rclone backends

- Nix specific
- [x] pr-tracker
  - [ ] https://github.com/matt1432/pr-tracker/issues/1
  - WIP https://github.com/NixOS/nixpkgs/pull/334482
  - [ ] make it work with local clone (not /var/lib)
    - and send a pr
    - as of now it works with /shed/Projects/nixhome/nixpkgs (own module based on mat1432's module)
- [x] lightweight pr-tracker
  - nixpkgs-tracker (has less branches)
- [x] nixos landscape
  - always facing SSL errors
  - author is busy with non-nix things
- [ ] home-manager-option-search
- [ ] nixos-search
- [ ] old versions tracker
  - database goes ballistic 13GB
- [ ] ofborg (necessary?)
  - https://github.com/NixOS/ofborg/wiki/Operating-a-Builder
  - ofborg offical sponsorship ended jan 1 2025, nixpkgs is moving to gha
- [ ] docs (all)
  - https://github.com/phanirithvij/mmdoc-nixpkgs-toc-gen

- pdf and docs tools
  - striling-pdf
    - ocrmypdf
  - gImageReader (ocr)
  - https://sioyek-documentation.readthedocs.io/en/latest/configuration.html
  - w3mman (key : for loading urls in manpages)
  - pinfo is bad (see pinfo lf)
  - xournalpp (notes wacom)
  - rnote (notes wacom)
  - pinta
  - sumatrapdf (wine, used it before, was good)
    - https://github.com/emmanuelrosa/sumatrapdf-nix
  - yacreader

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
