{ keys, pkgs, ... }:
let
  authorizedKeys = [
    keys.users.miyuki.mpointec
    keys.users.pabu.krapaince
  ];
in
{

  boot = {
    initrd = {
      availableKernelModules = [
        # USB Attached SCS
        "uas"
        # https://discourse.nixos.org/t/ssh-and-network-in-initrd-on-raspberry-pi-4/6289/3
        "genet"
      ];
      systemd.tpm2.enable = false;

      systemd = {
        users.root.shell = "/bin/systemd-tty-ask-password-agent";

        services.sshd = {
          after = [ "setup-ssh-key.service" ];
          requires = [ "setup-ssh-key.service" ];
        };
        services.setup-ssh-key = {
          description = "Setup host key for SSH Daemon";
          unitConfig = {
            DefaultDependencies = "no";
            Requires = "dev-sda1.device";
            After = "dev-sda1.device";
          };
          serviceConfig = {
            RemainAfterExit = true;
            Type = "oneshot";
          };
          script = ''
            mkdir /mnt
            mkdir -p /etc/ssh
            mount /dev/sda1 /mnt
            cp /mnt/ssh_host_ed25519_key_initrd /etc/ssh/ssh_host_ed25519_key
            chmod 400 /etc/ssh/ssh_host_ed25519_key
            umount /mnt
          '';
        };
      };

      network = {
        enable = true;
        ssh = {
          enable = true;
          # Prevent conflict in known hosts
          port = 23;
          inherit authorizedKeys;
          # Usage of initrd's secrets isn't supported for
          # generic-extlinux-compatible boot loader
          ignoreEmptyHostKeys = true;
          extraConfig = ''
            HostKey /etc/ssh/ssh_host_ed25519_key
          '';
        };
      };
    };

    kernelParams = [
      # https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt#:~:text=ip=%3Cclient-ip%3E:%3Cserver-ip%3E:%3Cgw-ip%3E:%3Cnetmask%3E:%3Chostname%3E:%3Cdevice%3E:%3Cautoconf%3E
      "ip=192.168.1.57::192.168.1.1:255.255.255.0:momo::none"
      "console=tyAMA0,115200"
      "console=tty1"
      # "rd.systemd.debug_shell"
    ];
  };

  systemd.services.flush-initrd-ip = {
    description = "Remove initrd static IP";
    before = [ "network-pre.target" ];
    wants = [ "network-pre.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.iproute2}/bin/ip addr flush dev end0";
    };
    wantedBy = [ "network-pre.target" ];
  };

  powerManagement.cpuFreqGovernor = "ondemand";
}
