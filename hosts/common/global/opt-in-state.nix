{ inputs, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/etc/NetworkManager/system-connections"
    ];
  };

  # TODO Move /etc/passwd and /etc/shadow to /persist/etc
  # Temporary add machine-id to config or let it create if then move it to /persist if regular file
  #   https://discourse.nixos.org/t/impermanence-a-file-already-exists-at-etc-machine-id/20267/5
  # Manually move /etc/shadow /etc/passwd ? <=> mutableUsers = false

  boot.initrd.systemd = {
    enable = true;
    services = {
      rollback = {
        wantedBy = [ "initrd.target" ];
        after = [ "zfs-import-zfspool.service" ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          zfs rollback -r zfspool/local/root@blank
        '';
      };

      persisted-files = {
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
  };
}
