{ inputs, config, ... }:
let
  wireless-interface = config.network-interfaces.wireless;
in
{
  networking.networkmanager.ensureProfiles = {
    environmentFiles = with config.sops; [
      secrets."wireless/secret-base/ssid".path
      secrets."wireless/secret-base/psk".path
    ];

    profiles = {
      secret-base = {
        connection = {
          id = "$SECRET_BASE_SSID";
          type = "wifi";
          interface = "${wireless-interface}";
        };

        wifi = {
          band = "bg";
          mode = "infrastructure";
          ssid = "$SECRET_BASE_SSID";
        };

        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$SECRET_BASE_PSK";
        };

        ipv4.method = "auto";

        ipv6 = {
          addr-gen-mode = "stable-privacy";
          method = "auto";
        };
      };
    };
  };

  sops.secrets =
    let
      secrets-path = builtins.toString inputs.secrets;
    in
    {
      "wireless/secret-base/ssid".sopsFile = "${secrets-path}/hosts/common.yaml";
      "wireless/secret-base/psk".sopsFile = "${secrets-path}/hosts/common.yaml";
    };
}
