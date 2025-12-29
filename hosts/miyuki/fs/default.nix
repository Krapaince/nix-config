let
  cryptroot_device = "/dev/disk/by-uuid/52064aee-2974-4b98-b541-de9e82c7fabb";
in
{
  boot.initrd = {
    availableKernelModules = [
      "cryptd"
    ];

    luks.devices."cryptroot" = {
      # https://askubuntu.com/questions/243518/what-exactly-do-the-allow-discards-and-root-trim-linux-parameters-do
      allowDiscards = true;
      # https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
      bypassWorkqueues = true;

      device = "/dev/disk/by-uuid/c40932f4-e5c9-4847-ae7f-5c65e161a2a9";
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/330A-BE8B";
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
      size = 24 * 1024;
    }
  ];
}
