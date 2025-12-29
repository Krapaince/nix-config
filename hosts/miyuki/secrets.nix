{ inputs, ... }:
let
  secretsPath = builtins.toString inputs.secrets;
  miyukiFile = secretsPath + "/hosts/miyuki.yaml";
in
{
  sops.secrets = {
    "wireless/office-access/ssid".sopsFile = miyukiFile;
    "wireless/office-access/ssid2".sopsFile = miyukiFile;
    "wireless/office-access/password".sopsFile = miyukiFile;
  };
}
