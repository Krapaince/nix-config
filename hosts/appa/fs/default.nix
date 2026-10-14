let
  cryptroot_device = "/dev/disk/by-uuid/abbd3174-c910-4f87-a9a1-53529d191c7e";
in
{
  imports = [
    ./storage.nix
  ];

  boot.initrd = {
    availableKernelModules = [
      "cryptd"
    ];

    luks.devices."cryptroot" = {
      # https://askubuntu.com/questions/243518/what-exactly-do-the-allow-discards-and-root-trim-linux-parameters-do
      allowDiscards = true;
      # https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
      bypassWorkqueues = true;

      device = "/dev/disk/by-uuid/b449a93e-8d5a-449d-a1a3-1b3d038ce7d0";
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/403B-04CA";
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
