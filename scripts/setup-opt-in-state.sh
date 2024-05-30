#!/usr/bin/env bash

# https://github.com/kjhoerr/dotfiles/wiki/NixOS:-Instructions-for-adding-a-new-system

MNT="/mnt"
PERSIST="$MNT/persist/system"

mkdir -p $PERSIST/etc/NetworkManager/system-connections
mkdir -p $PERSIST/var/lib/{bluetooth,nixos,systemd,NetworkManager}
mkdir -p $PERSIST/var/log

cp -R {$MNT,$PERSIST}/etc/NetworkManager/system-connections

mv {$MNT,$PERSIST}/etc/machine-id
mv {$MNT,$PERSIST}/var/lib/NetworkManager/secret_key
mv {$MNT,$PERSIST}/var/lib/NetworkManager/timestamps
mv {$MNT,$PERSIST}/var/lib/NetworkManager/seen-bssids

# Temporary while secret aren't implemented
mv {$MNT,$PERSIST}/etc/shadow
mv {$MNT,$PERSIST}/etc/passwd
