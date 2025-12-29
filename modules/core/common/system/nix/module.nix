{ lib, self, ... }:
let
  inherit (self) inputs;

  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  nix = {
    # Add each flake input as a registry and nix path
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command flakes pipe-operators" ];
      keep-outputs = true;
      warn-dirty = false;
    };

    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 30d";
      persistent = false;
    };

    optimise = {
      automatic = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
