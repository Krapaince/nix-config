{ lib, inputs, outputs, config, ... }: {
  imports = [
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.home-manager

    (lib.custom.relativeToRoot "modules/common")

    ./fish.nix
    ./locale.nix
    ./nix.nix
    ./opt-in-state.nix
    ./sops.nix
    ./ssh.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  hostSpec = {
    identity = inputs.secrets.personal;
    username = "krapaince";
  };

  networking.hostName = config.hostSpec.hostName;

  home-manager.useGlobalPkgs = true;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  hardware.enableRedistributableFirmware = true;
}
