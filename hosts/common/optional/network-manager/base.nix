{ inputs, config, ... }:
let wireless-interface = config.network-interfaces.wireless;
in {
  networking.networkmanager.ensureProfiles = {
    environmentFiles = with config.sops; [
      secrets."wireless/base/ssid".path
      secrets."wireless/base/psk".path
    ];

    profiles = {
      base = {
        connection = {
          id = "$BASE_SSID";
          type = "wifi";
          interface = "${wireless-interface}";
        };

        wifi = {
          mode = "infrastructure";
          ssid = "$BASE_SSID";
        };

        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$BASE_PSK";
        };

        ipv4.method = "auto";

        ipv6 = {
          addr-gen-mode = "stable-privacy";
          method = "auto";
        };
      };
    };
  };

  sops.secrets = let secrets-path = builtins.toString inputs.secrets;
  in {
    "wireless/base/ssid".sopsFile = "${secrets-path}/hosts/common.yaml";
    "wireless/base/psk".sopsFile = "${secrets-path}/hosts/common.yaml";
  };
}
