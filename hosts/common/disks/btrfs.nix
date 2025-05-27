{ lib, disk, withSwap ? false, swapSize, ... }: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = disk;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                extraOpenArgs = [
                  # https://askubuntu.com/questions/243518/what-exactly-do-the-allow-discards-and-root-trim-linux-parameters-do
                  "--allow-discards"
                  # https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-L" "nixos" "-f" ];
                  postCreateHook = ''
                    MNTPOINT="$(mktemp -d)"
                    mount "/dev/mapper/cryptroot" "$MNTPOINT" -o subvolid=5
                    trap "umount $MNTPOINT; rm -rf $MNTPOINT/root $MNTPOINT/root-blank" EXIT
                    btrfs subvolume snapshot -r $MNTPOINT/root $MNTPOINT/root-blank
                  '';
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions =
                        [ "subvol=root" "compress=zstd" "noatime" ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "subvol=home" "compress=zstd" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions =
                        [ "subvol=nix" "compress=zstd" "noatime" "noacl" ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "subvol=persist" "compress=zstd" ];
                    };
                    "/swap" = lib.mkIf withSwap {
                      mountpoint = "/swap";
                      swap.swapfile.size = "${swapSize}G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
