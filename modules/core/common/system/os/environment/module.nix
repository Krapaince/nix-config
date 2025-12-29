{ lib, ... }:
{
  imports = [
    ./locale.nix
    ./packages.nix
    ./variables.nix
  ];

  time.timeZone = lib.mkDefault "Europe/Paris";
}
