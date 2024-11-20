{ inputs, config, ... }:
let homeDirectory = config.home.homeDirectory;
in {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = { age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt"; };
}
