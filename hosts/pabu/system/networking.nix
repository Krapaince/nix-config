{ config, ... }:
let
  secrets = config.sops.secrets;
in
{
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      secrets.wireguard-private-key.path
      secrets.appa-dn.path
      secrets."wireguard/port".path
    ];

    profiles = {
      appa-wireguard = {
        connection = {
          id = "Appa wireguard";
          type = "wireguard";
          interface-name = "appa-wireguard";
          autoconnect = false;
        };

        wireguard.private-key = "$PABU_PRIVATE_KEY";

        "wireguard-peer.GsM3Xukmg69J2kBf2iBOYgTR7caME3MiaqgjXe+rYkY=" = {
          endpoint = "$APPA_DN:$WIREGUARD_PORT";
          allowed-ips = "10.0.0.0/24";
        };

        ipv4 = {
          address1 = "10.0.0.2/24";
          method = "manual";
        };

        ipv6 = {
          addr-gen-mode = "stable-privacy";
          method = "disabled";
        };
      };
    };
  };
}
