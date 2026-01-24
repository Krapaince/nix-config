{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) foldr recursiveUpdate;

  customLib = mergeLibs [
    (import ./modules.nix { inherit inputs lib; })
    (import ./builders.nix { inherit inputs lib; })
    (import ./hardware { inherit lib; })
    (import ./themes.nix { inherit lib; })
  ];

  mergeLibs = foldr recursiveUpdate { };

  extendedLibrary = inputs.nixpkgs.lib.extend (_: _: { custom = customLib; });
in
{
  perSystem._module.args.lib = extendedLibrary;
  flake.lib = extendedLibrary;
}
