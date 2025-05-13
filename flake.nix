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
      url =
        "git+ssh://git@gitlab.com/Krapaince/nix-config-secret.git?ref=master&shallow=1";
      flake = false;
    };

    hyprland-ipc = {
      url = "github:Krapaince/hyprland-ipc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi-flavor = {
      url = "github:yazi-rs/flavors";
      flake = false;
    };

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, systems, ... }@inputs:
    let
      inherit (self) outputs;
      # https://github.com/nix-community/home-manager/pull/3454#issuecomment-1472325946
      lib = nixpkgs.lib.extend
        (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });

      forEachSystem = f:
        lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        });

      configVars = import ./vars;
      specialArgs = { inherit inputs outputs lib configVars; };
    in {
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

        momo = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./hosts/momo ];
        };

        pabu = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./hosts/pabu ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "krapaince@momo" = home-manager.lib.homeManagerConfiguration {
          modules = [ ./home/krapaince/momo ./home/krapaince/nixpkgs.nix ];
          pkgs = pkgsFor.aarch64-linux;
          extraSpecialArgs = specialArgs;
        };

        "krapaince@pabu" = home-manager.lib.homeManagerConfiguration {
          modules = [ ./home/krapaince/pabu ./home/krapaince/nixpkgs.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = specialArgs;
        };
      };
    };
}
