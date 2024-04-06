{
  description = "Krapaince's Nix-Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }@inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    });
  in {
    inherit lib;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      momo = nixpkgs.lib.nixosSystem {
        modules = [ ./hosts/momo ];
        specialArgs = { inherit inputs outputs; };
      };

      krapaince-nixos = nixpkgs.lib.nixosSystem {
        modules = [ ./nixos/configuration.nix ];
        specialArgs = {inherit inputs outputs;};
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "krapaince@momo" = home-manager.lib.homeManagerConfiguration {
        modules = [ ./home/krapaince/momo.nix ];
        pkgs = pkgsFor.aarch64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
      };
    };
  };
}
