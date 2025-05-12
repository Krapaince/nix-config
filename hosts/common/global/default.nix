{ inputs, outputs, ... }: {
  imports = [
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.home-manager

    ./fish.nix
    ./locale.nix
    ./nix.nix
    ./opt-in-state.nix
    ./sops.nix
    ./ssh.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager.useGlobalPkgs = true;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  hardware.enableRedistributableFirmware = true;
}
