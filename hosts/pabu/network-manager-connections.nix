{ inputs, config, ... }: {
  imports = [ ../common/optional/network-manager/secret-based.nix ];

  networking.networkmanager.ensureProfiles = {
    environmentFiles = with config.sops; [
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

  sops.secrets = let secrets-path = builtins.toString inputs.secrets;
  in {
    wireguard-private-key.sopsFile = "${secrets-path}/hosts/pabu.yaml";
    appa-dn.sopsFile = "${secrets-path}/hosts/common.yaml";
    "wireguard/port".sopsFile = "${secrets-path}/hosts/common.yaml";
  };
}
