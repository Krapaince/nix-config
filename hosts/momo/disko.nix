{
  boot = {
    initrd.supportedFilesystems = [ "vfat" "btrfs" ];
    supportedFilesystems = [ "vfat" "btrfs" ];
  };
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/usb-Argon_Forty_000000000F02-0:0";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1024M";
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
                    "/srv" = {
                      mountpoint = "/srv";
                      mountOptions =
                        [ "subvol=srv" "compress=zstd" "acl" "noexec" ];
                    };
                    "/swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "8G";
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
