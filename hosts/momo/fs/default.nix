let
  cryptroot_device = "/dev/disk/by-uuid/16e93764-dea0-459e-8f4c-4799a97ba3d8";
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

      device = "/dev/disk/by-uuid/c29c3673-3b3d-45d6-947c-4ab02d7aaec8";
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/12CE-A600";
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

    "/var/log" = {
      device = cryptroot_device;
      fsType = "btrfs";
      options = [ "subvol=log" ];
      neededForBoot = true;
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

  swapDevices = [ { device = "/swap/swapfile"; } ];
}
