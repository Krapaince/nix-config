{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.modules.system.impermanence;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  config = mkIf cfg.enable {
    users = {
      mutableUsers = false;
    };

    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd"
        "/etc/NetworkManager/system-connections"
      ];
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
          set -e

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
      description = "Hard-link persisted files from /persist";
      wantedBy = [ "initrd.target" ];
      after = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      # man 7 bootup
      script = ''
        mkdir -p /sysroot/etc
        ln -snfT /persist/system/etc/machine-id /sysroot/etc/machine-id
      '';
    };
  };
}
