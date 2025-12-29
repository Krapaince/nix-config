{ inputs, ... }:
let
  secretsPath = builtins.toString inputs.secrets;
  pabuFile = secretsPath + "/hosts/pabu.yaml";
in
{
  sops.secrets = {
    wireguard-private-key.sopsFile = pabuFile;
  };
}
