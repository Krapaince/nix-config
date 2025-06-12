{ config, lib, inputs, ... }:
let wirelessInterface = config.network-interfaces.wireless;
in {
  imports =
    [ (lib.custom.relativeToRoot "hosts/common/optional/network-manager") ];

  networking.networkmanager.ensureProfiles = {
    environmentFiles = with config.sops; [
      secrets."wireless/office-access/ssid".path
      secrets."wireless/office-access/ssid2".path
      secrets."wireless/office-access/password".path
    ];

    profiles = let
      makeOfficeProfiles = name: ssid: {
        name = name;
        value = {
          connection = {
            id = name;
            type = "wifi";
            interface = wirelessInterface;
          };

          wifi = {
            mode = "infrastructure";
            ssid = ssid;
          };

          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-eap";
          };

          "802-1x" = {
            eap = "ttls";
            identity = builtins.elemAt
              (lib.strings.split "@" config.hostSpec.identity.email) 0;
            password = "$OFFICE_ACCESS_PASSWORD";
            phase2-auth = "mschapv2";
          };

          ipv4.method = "auto";

          ipv6 = {
            addr-gen-mode = "stable-privacy";
            method = "auto";
          };
        };
      };
      profiles = [
        [ "office-access" "$OFFICE_ACCESS_SSID" ]
        [ "office-access-rdc" "$OFFICE_ACCESS_SSID2" ]
      ];
    in builtins.listToAttrs (builtins.map
      (e: makeOfficeProfiles (builtins.elemAt e 0) (builtins.elemAt e 1))
      profiles);

  };

  sops.secrets = let secretsPath = "${inputs.secrets}/hosts/miyuki.yaml";
  in {
    "wireless/office-access/ssid".sopsFile = secretsPath;
    "wireless/office-access/ssid2".sopsFile = secretsPath;
    "wireless/office-access/password".sopsFile = secretsPath;
  };
}
