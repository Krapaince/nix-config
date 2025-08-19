{ inputs, config, ... }:
let
  secretsPath = builtins.toString inputs.secrets;
  homeDirectory = config.home.homeDirectory;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      "bluetooth/headset_addr" = {
        sopsFile = "${secretsPath}/hosts/common.yaml";
      };
    };
  };
}
