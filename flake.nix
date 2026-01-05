{
  description = "Krapaince's Nix-Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    systems.url = "github:nix-systems/default-linux";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@gitlab.com/Krapaince/nix-config-secret.git?ref=master&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-ipc = {
      url = "github:Krapaince/hyprland-ipc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-config-work = {
      url = "git+ssh://git@gitlab.com/Krapaince/nix-config-work.git?ref=master&shallow=1";
      # nix flake update nix-config-work
      # url = "path:/home/mpointec/Desktop/GIT/nix-config-work";
      flake = false;
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        ./parts
        ./hosts
      ];
    };
}
