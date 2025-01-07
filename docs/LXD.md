https://srid.ca/lxc-nixos
https://www.thedroneely.com/posts/running-nixos-linux-containers/
https://github.com/nix-community/nixos-generators/issues/79

Would you like to use LXD clustering? (yes/no) [default=no]:
Do you want to configure a new storage pool? (yes/no) [default=yes]:
Name of the new storage pool [default=default]:
Name of the storage backend to use (btrfs, dir, lvm) [default=btrfs]:
Would you like to create a new btrfs subvolume under /var/lib/lxd? (yes/no) [default=yes]:
Would you like to connect to a MAAS server? (yes/no) [default=no]:
Would you like to create a new local network bridge? (yes/no) [default=yes]:
What should the new bridge be called? [default=lxdbr0]:
What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]:
What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]:
Would you like the LXD server to be available over the network? (yes/no) [default=no]: yes
Address to bind LXD to (not including port) [default=all]:
Port to bind LXD to [default=8443]:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]:
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: yes
config:
core.https_address: '[::]:8443'
networks:

- config:
  ipv4.address: auto
  ipv6.address: auto
  description: ""
  name: lxdbr0
  type: ""
  project: default
  storage_pools:
- config:
  source: /var/lib/lxd/storage-pools/default
  description: ""
  name: default
  driver: btrfs
  storage_volumes: []
  profiles:
- config: {}
  description: ""
  devices:
  eth0:
  name: eth0
  network: lxdbr0
  type: nic
  root:
  path: /
  pool: default
  type: disk
  name: default
  projects: []
  cluster: null
