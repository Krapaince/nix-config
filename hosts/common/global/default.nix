{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./fish.nix
    ./locale.nix
    ./nix.nix
    # ./openssh.nix
  ];

  nix.settings.warn-dirty = false;
  nixpkgs.config.allowUnfree = true;

  hardware.enableRedistributableFirmware = true;
}
