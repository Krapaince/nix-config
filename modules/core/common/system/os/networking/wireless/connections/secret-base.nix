{ config, lib, ... }:
let
  inherit (lib) mkIf;

  secrets = config.sops.secrets;
  networking = config.modules.system.networking;
  wireless = networking.wireless;
  wirelessInterface = networking.interfaces.wireless;
in
{
  config = mkIf wireless.connections.secretBase'.enable {
    networking.networkmanager.ensureProfiles = {
      environmentFiles = [
        secrets."wireless/secret-base/ssid".path
        secrets."wireless/secret-base/psk".path
      ];

      profiles = {
        secret-base = {
          connection = {
            id = "$SECRET_BASE_SSID";
            type = "wifi";
            interface = wirelessInterface;
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
  };
}
