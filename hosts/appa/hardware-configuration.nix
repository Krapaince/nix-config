{ keys, ... }:
let
  authorizedKeys = [
    keys.users.miyuki.mpointec
    keys.users.pabu.krapaince
  ];
in
{
  config = {
    boot.initrd = {
      availableKernelModules = [
        "cryptd"
        "igb"
      ];

      systemd = {
        users.root.shell = "/bin/systemd-tty-ask-password-agent";

        network = {
          enable = true;
          networks."10-wired" = {
            matchConfig.MACAddress = "70:85:c2:7f:74:b2";
            address = [ "192.168.1.68/24" ];
            gateway = [ "192.168.1.1" ];
            dns = [ "192.168.1.1" ];
          };
        };
      };

      network.ssh = {
        enable = true;
        port = 23;
        hostKeys = [ "/persist/system/etc/ssh/initrd/ssh_host_ed25519_key" ];
        authorizedKeys = authorizedKeys;
      };
    };
  };
}
