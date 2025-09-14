{ lib, ... }:
{
  lib,
  pkgs,
  ...
}:
{
  home.packages = builtins.map (path: pkgs.callPackage path { }) (lib.custom.scanPaths ./.);
}
