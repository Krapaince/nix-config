{ lib, inputs, outputs, config, pkgs, ... }: {
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
    identity = inputs.secrets.identities.personal;
    username = "krapaince";
  };

  networking.hostName = config.hostSpec.hostName;

  home-manager.useGlobalPkgs = true;

  environment.systemPackages = with pkgs; [ neovim screen vifm ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = lib.mkDefault "25.05";
}
