{
  description = "Krapaince's Nix-Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    systems.url = "github:nix-systems/default-linux";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    yazi-flavor = {
      url = "github:yazi-rs/flavors";
      flake = false;
    };

    nix-config-work = {
      url = "git+ssh://git@gitlab.com/Krapaince/nix-config-work.git?ref=master&shallow=1";
      # nix flake update nix-config-work
      # url = "path:/home/mpointec/Desktop/GIT/nix-config-work";
      flake = false;
    };

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # https://github.com/nix-community/home-manager/pull/3454#issuecomment-1472325946
      lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });

      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

      specialArgs = { inherit inputs outputs lib; };
    in
    {
      inherit lib;
      nixosModules = import ./modules/nixos;

      overlays = import ./overlays { inherit inputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        iso = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./hosts/iso ];
        };

        miyuki = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./hosts/miyuki ];
        };

        momo = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./hosts/momo ];
        };

        pabu = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./hosts/pabu ];
        };
      };
    };
}
