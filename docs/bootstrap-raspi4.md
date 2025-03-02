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

## Install the UEFI firmware

- Download a release of the Raspberry PI 4 [UEFI
  firmware](https://github.com/pftf/RPi4/releases)
    - Last bootstrap with version `v1.37`
- Extract the content of the release at the root of the boot partition
  (`/boot`)
```
> tree -L 1
/boot
├── bcm2711-rpi-400.dtb
├── bcm2711-rpi-4-b.dtb
├── bcm2711-rpi-cm4.dtb
├── config.txt
├── EFI
├── firmware
├── fixup4.dat
├── loader
├── overlays
├── RPI_EFI.fd
├── start4.elf
└── ubootefi.var
```

## Install the Raspberry PI device tree overlays

- Download the [Raspberry PI
  OS](https://www.raspberrypi.com/software/operating-systems/)
    - Last bootstrap with version
      [2024-11-19](https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2024-11-19/2024-11-19-raspios-bookworm-armhf-lite.img.xz)
- Extract the overlays
```bash
xz --decompress <image>.img.xz
losetup /dev/loop0 <image>.img
partx -u /dev/loop0
mkdir /tmp/firmware
mount /dev/loop0p1 /tmp/firmware
mkdir /tmp/boot
mount /dev/<boot-partition> /tmp/boot
mkdir -p /tmp/boot/overlays
cp /tmp/firmware/overlays/* /tmp/efi/overlays
```

## Post install

Two things need to be change in the UEFI Firmware setting:
1. Remove the 3GB limit on RAM. Go to `Device Manager` -> `Raspberry PI
   Configuration` -> `Advanced Settings` and disable the limit.
2. In the same `Advanced settings` page, change the second item from `ACPI` to
   `ACPI + Devide Tree`

Hit `F10` to save and `Esc` to go back to the main page. Use `Continue` to
resume booting.

---
References:
- [NixOS on Raspberry Pi 4 over
  USB](https://github.com/adtya/wiki/blob/a5df4b99f9380157a1da71608ba8eaa661446033/src/nix/nix-on-pi.md)
