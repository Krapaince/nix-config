{
  withSystem,
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.self) lib;
      inherit (lib.custom) mkModuleTree mkNixosSystem;
      inherit (lib.lists) concatLists flatten singleton;

      hw = inputs.hardware.nixosModules;
      hm = inputs.home-manager.nixosModules.home-manager;

      modulePath = ../modules;

      coreModules = modulePath + /core;
      options = modulePath + /options;

      common = coreModules + /common;
      profiles = coreModules + /profiles;

      graphical = coreModules + /roles/graphical;
      headless = coreModules + /roles/headless;
      laptop = coreModules + /roles/laptop;
      server = coreModules + /roles/server;
      workstation = coreModules + /roles/workstation;

      homesPath = ../homes;
      homes = [
        hm
        homesPath
      ];

      mkModuleFor =
        hostname:
        {
          moduleTrees ? [
            common
            options
            profiles
          ],
          roles ? [ ],
          extraModules ? [ ],
        }:
        [
          (singleton ./${hostname}/host.nix)

          (
            [
              moduleTrees
              roles
            ]
            |> concatLists
            |> (map (
              path:
              mkModuleTree {
                inherit path;
                suffix = "module.nix";
              }
            ))
          )

          extraModules
        ]
        |> concatLists
        |> flatten;
    in
    {
      pabu = mkNixosSystem {
        inherit withSystem;
        hostname = "pabu";
        system = "x86_64-linux";
        specialArgs = { inherit lib; };
        modules = mkModuleFor "pabu" {
          roles = [
            graphical
            laptop
            workstation
          ];
          extraModules = [
            homes
            hw.lenovo-thinkpad-t480
          ];
        };
      };

      miyuki = mkNixosSystem {
        inherit withSystem;
        hostname = "miyuki";
        system = "x86_64-linux";
        specialArgs = { inherit lib; };
        modules = mkModuleFor "miyuki" {
          roles = [
            graphical
            laptop
            workstation
          ];
          extraModules = [
            homes
            hw.lenovo-thinkpad-p14s-amd-gen2
          ];
        };
      };

      momo = mkNixosSystem {
        inherit withSystem;
        hostname = "momo";
        system = "aarch64-linux";
        specialArgs = { inherit lib; };
        modules = mkModuleFor "momo" {
          roles = [
            server
            headless
          ];
          extraModules = [
            homes
            inputs.hardware.nixosModules.raspberry-pi-4
          ];
        };
      };
    };
}
