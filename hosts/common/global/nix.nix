{ inputs, lib, pkgs, ... }:
let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in {
  nix = {
    package = pkgs.nixVersions.nix_2_18;

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command flakes" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than +3";
    };

    # Add each flake input as a registry and nix_path
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
}
