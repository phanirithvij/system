#!/usr/bin/env bash

sudo mkdir -p /mnt/{nix,home,shed,} /mnt/boot/efi
sudo mount /dev/disk/by-label/nixroot -o subvol=vols/@ /mnt
sudo mount /dev/disk/by-label/nixroot -o subvol=vols/@nix /mnt/nix   # nix partition
sudo mount /dev/disk/by-label/nixroot -o subvol=vols/@shed /mnt/shed # has my nixos config
sudo mount /dev/disk/by-label/nixroot -o subvol=vols/@home /mnt/home # has my ssh sops secret
sudo mount /dev/disk/by-label/boot /mnt/boot/efi/                    # important! should be /boot/efi not /boot
sudo nixos-enter
