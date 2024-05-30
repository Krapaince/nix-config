let
  zpool_name = "zfspool";
  root_fs_name = "local/root";
in {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5001b448b876d9a3";
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
                name = "crypt";
                extraOpenArgs = [ "--allow-discards" ];
                content = {
                  type = "zfs";
                  pool = zpool_name;
                };
              };
            };
          };
        };
      };
    };

    zpool.zfspool = {
      type = "zpool";
      options = { ashift = "12"; };
      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        canmount = "off";
        compression = "lz4";
        xattr = "sa";
      };

      datasets = {
        "${root_fs_name}" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/";
          postCreateHook =
            "zfs list -t snapshot -H -o name | grep -E '^${zpool_name}/${root_fs_name}@blank$' || zfs snapshot ${zpool_name}/${root_fs_name}@blank";
        };

        "local/nix" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/nix";
        };
        "safe/home" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/home";
        };
        "safe/persist" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/persist";
        };
      };
    };
  };
}
