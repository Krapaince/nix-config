# NixOS on Raspberry PI 4B over USB

A guide to bootstrap my Raspberry PI 4b with NixOS.

## Requirements

- A Raspberry PI 4B
- An SD card
- A USB Drive

## Preparing the PI to boot from USB

Using the `rpi-imager` make the PI boot from USB:
- write the `Misc utility images -> Bootloader (PI 4 family) -> USB Boot` to SD
  card
- boot the PI with it
- wait for 10-15secs

## Preparing the installer SD card

- Download a version of the aarch64 SD card image from
  [Hydra](https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux)
    - Last bootstrap with version
      `nixos-image-sd-card-25.05beta760502.6313551cd054-aarch64-linux.img.zst`
- Decompress the image
```bash
unzstd -d <image-file.img.zst>
```
- Burn ISO image to SD card
```bash
dd if=<image-file.img> of=/dev/<sd-card> conv=sync,noerror bs=128k status=progress
```

## Installing

- Unplug the USB drive and plug the SD card
- Fire up the PI
- Once the installer booted, replug the USB drive
- Follow the usual [bootstrap](./bootstrap.md) but don't reboot once install
- Generate the host initrd private key and put it under `/persist/system/etc/ssh/ssh_host_ed25519_key`

## Copy the firmware to the `/boot` partition

Raspberry PIs require special firmware which by default does not get installed
onto the `/boot` partition. However, the installer does have it and we just
need to copy it:
```bash
sudo mkdir /firmware
sudo mount /dev/<sd*>1 /firmware
sudo cp -r /firmware/* /mnt/boot
```

---
References:
- [NixOS on Raspberry Pi
  4](https://thehellings.com/posts/nixos-on-raspberry-pi-4/)
