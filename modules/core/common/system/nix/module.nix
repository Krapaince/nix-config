{ self, ... }:
let
  inherit (self) inputs;
in
{
  nix = {
    # Add each flake input as a registry and nix path
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };

    nixPath = [ "nixpkgs=flake:nixpkgs" ];

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
