{ config, lib, ... }:
let
  inherit (lib) mkIf;

  secrets = config.sops.secrets;
  networking = config.modules.system.networking;
  wireless = networking.wireless;
  wirelessInterface = networking.interfaces.wireless;
in
{
  config = mkIf wireless.connections.base'.enable {
    networking.networkmanager.ensureProfiles = {
      environmentFiles = [
        secrets."wireless/base/ssid".path
        secrets."wireless/base/psk".path
      ];

      profiles = {
        base = {
          connection = {
            id = "$BASE_SSID";
            type = "wifi";
            interface = wirelessInterface;
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
  };
}
