{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages = builtins.map (path: pkgs.callPackage path { inherit config; }) (
    lib.custom.scanPaths ./.
  );
}
