{ inputs, outputs, ... }: {
  imports = [
    ./fish.nix
    ./locale.nix
    ./nix.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableRedistributableFirmware = true;
}
