{ inputs, config, configVars, ... }:
let
  isEd25519 = key: key.type == "ed25519";
  getKeyPath = key: key.path;
  keys = if config.services.openssh.enable then
    builtins.filter isEd25519 config.services.openssh.hostKeys
  else [{
    path = configVars.hostKeyPath;
  }];
in {
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops.age.sshKeyPaths = map getKeyPath keys;
}
