#!/usr/bin/env bash

# https://github.com/kjhoerr/dotfiles/wiki/NixOS:-Instructions-for-adding-a-new-system

MNT="/mnt"
PERSIST="$MNT/persist/system"

mkdir -p $PERSIST/etc/NetworkManager/system-connections
# https://man.archlinux.org/man/NetworkManager.8.en#/VAR/LIB/NETWORKMANAGER/SECRET_KEY_AND_/ETC/MACHINE-ID
mkdir -p $PERSIST/var/lib/{bluetooth,nixos,systemd,NetworkManager}
mkdir -p $PERSIST/var/log

cp -R {$MNT,$PERSIST}/etc/NetworkManager/system-connections

# Generate machine-id
head -c4 /dev/urandom | od -A none -t x4 > "$PERSIST/etc/machine-id"

mv {$MNT,$PERSIST}/var/lib/NetworkManager/secret_key
mv {$MNT,$PERSIST}/var/lib/NetworkManager/timestamps
mv {$MNT,$PERSIST}/var/lib/NetworkManager/seen-bssids
