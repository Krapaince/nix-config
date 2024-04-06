{ inputs, lib, pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.nix_2_18;

    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command flakes"];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than +3"
    };

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

    nixPath = ["/etc/nix/path"];
  };
}
