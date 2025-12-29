let
  cryptroot_device = "/dev/disk/by-uuid/fb10f65c-f0a0-46e6-a472-8dd830fa3b38";
in
{
  boot.initrd = {
    availableKernelModules = [
      "aesni_intel"
      "cryptd"
    ];

    luks.devices."cryptroot" = {
      # https://askubuntu.com/questions/243518/what-exactly-do-the-allow-discards-and-root-trim-linux-parameters-do
      allowDiscards = true;
      # https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
      bypassWorkqueues = true;

      device = "/dev/disk/by-uuid/8d9fe47a-a046-44a8-b8a5-74b3f128dda4";
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/D0E9-3A79";
      fsType = "vfat";
    };

    "/" = {
      device = cryptroot_device;
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
        "noatime"
      ];
    };

    "/persist" = {
      device = cryptroot_device;
      fsType = "btrfs";
      neededForBoot = true;
      options = [
        "subvol=persist"
        "compress=zstd"
      ];
    };

    "/nix" = {
      device = cryptroot_device;
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];
    };

    "/home" = {
      device = cryptroot_device;
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd"
      ];
    };

    "/swap" = {
      device = cryptroot_device;
      fsType = "btrfs";
      options = [
        "subvol=swap"
        "noatime"
      ];
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024;
    }
  ];
}
