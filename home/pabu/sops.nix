{ inputs, config, ... }:
let
  secrets-path = builtins.toString inputs.secrets;
  homeDirectory = config.home.homeDirectory;

in {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      "bluetooth/headset_addr" = {
        sopsFile = "${secrets-path}/hosts/common.yaml";
      };
    };
  };
}
