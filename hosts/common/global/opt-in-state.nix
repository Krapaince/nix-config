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

  security.sudo.extraConfig = ''
    Defaults lecture="never"
  '';
}
