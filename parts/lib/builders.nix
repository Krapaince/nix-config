{ inputs, lib, ... }:
let
  inherit (inputs) self nixpkgs;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.lists) concatLists singleton;
  inherit (lib.modules) mkDefault;

  modulePath = "${nixpkgs}/nixos/modules";

  mkSystem = lib.nixosSystem;

  mkNixosSystem =
    {
      withSystem,
      system,
      hostname,
      ...
    }@args:
    withSystem system (
      { inputs', self', ... }:
      mkSystem {
        specialArgs = recursiveUpdate {
          inherit (self) keys;
          inherit lib modulePath;
          inherit
            inputs
            self
            inputs'
            self'
            ;
        } (args.specialArgs or { });

        modules = concatLists [
          (singleton
            # Inline module
            # This feels totally illegal but is supported
            # https://github.com/NixOS/nixpkgs/blob/9da06d4665c058e39cfdadcddb0a257a9096cb26/flake.nix#L53
            {
              networking.hostName = hostname;
              nixpkgs = {
                hostPlatform = mkDefault system;
                flake.source = nixpkgs.outPath;
              };
            }
          )

          (args.modules or [ ])
        ];
      }
    );
in
{
  inherit mkNixosSystem;
}
