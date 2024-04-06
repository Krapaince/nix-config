{ inputs, outputs, ... }: {
  imports = [
    ./fish.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableRedistributableFirmware = true;
}
