{ lib, ... }:
{
  imports = [
    ./bluetooth.nix
    ./cpu
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
