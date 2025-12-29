{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib) elemAt listToAttrs map;

  secrets = config.sops.secrets;
  wirelessInterface = config.modules.system.networking.interfaces.wireless;
  email = inputs.secrets.identities.work.email;

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
        identity = elemAt (lib.strings.split "@" email) 0;
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
in
{
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      secrets."wireless/office-access/ssid".path
      secrets."wireless/office-access/ssid2".path
      secrets."wireless/office-access/password".path
    ];

    profiles =
      [
        [
          "office-access"
          "$OFFICE_ACCESS_SSID"
        ]
        [
          "office-access-rdc"
          "$OFFICE_ACCESS_SSID2"
        ]
      ]
      |> (map (profile: makeOfficeProfiles (elemAt profile 0) (elemAt profile 1)))
      |> listToAttrs;
  };
}
