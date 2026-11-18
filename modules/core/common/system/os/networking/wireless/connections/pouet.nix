{ config, lib, ... }:
let
  inherit (lib) mkIf;

  secrets = config.sops.secrets;
  networking = config.modules.system.networking;
  wireless = networking.wireless;
  wirelessInterface = networking.interfaces.wireless;
in
{
  config = mkIf wireless.connections.pouet'.enable {
    networking.networkmanager.ensureProfiles = {
      environmentFiles = [
        secrets."wireless/pouet/ssid".path
        secrets."wireless/pouet/psk".path
      ];

      profiles = {
        pouet = {
          connection = {
            id = "$SSID";
            type = "wifi";
            interface = wirelessInterface;
          };

          wifi = {
            mode = "infrastructure";
            ssid = "$SSID";
          };

          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$PSK";
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
