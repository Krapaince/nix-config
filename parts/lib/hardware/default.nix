{ lib, ... }:
{
  resolveMonitors = import ./monitor.nix { inherit lib; };
}
