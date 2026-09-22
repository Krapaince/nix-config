{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) lists mkIf;

  sys = config.modules.system;
  cfg = sys.impermanence;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  config = mkIf cfg.enable {
    users = {
      mutableUsers = false;
    };

    environment.persistence."${cfg.mountpoint}/system" = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/var/lib/systemd"
      ]
      ++ (lists.optional sys.bluetooth.enable "/var/lib/bluetooth")
      ++ (lists.optional config.networking.wireless.enable "/etc/NetworkManager/system-connections");
    };

    boot.initrd.systemd = {
      enable = true;
      services.rollback = {
        description = "Rollback BTRFS subvolume";
        wantedBy = [ "initrd.target" ];
        after = [ "systemd-cryptsetup@cryptroot.service" ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /mnt
          mount -o subvolid=5 -t btrfs /dev/mapper/cryptroot /mnt
          btrfs subvolume list -o /mnt/root
          btrfs subvolume list -o /mnt/root \
          | cut -f9 -d ' ' \
          | while read subvolume; do
            echo "deleting /$subvolume subvolume..."
            btrfs subvolume delete "/mnt/$subvolume"
          done
          echo "deleting /root subvolume..."
          btrfs subvolume delete /mnt/root

          echo "restoring blank /root subvolume..."
          btrfs subvolume snapshot /mnt/root-blank /mnt/root

          umount /mnt
        '';
      };
    };

    boot.initrd.systemd.services.persisted-files = {
      description = "Hard-link persisted files from ${cfg.mountpoint}";
      wantedBy = [ "initrd.target" ];
      after = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      # man 7 bootup
      script = ''
        mkdir -p /sysroot/etc
        ln -snfT ${cfg.mountpoint}/system/etc/machine-id /sysroot/etc/machine-id
      '';
    };
  };
}
