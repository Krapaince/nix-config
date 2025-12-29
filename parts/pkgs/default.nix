{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      overlayAttrs = config.packages;
      packages = lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage newScope;
        directory = ./packages;
      };
    };
}
