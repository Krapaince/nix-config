{ pkgs, inputs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix

    ../common/global
    ../common/users/krapaince.nix
  ];

  networking = {
    hostName = "momo";
    useDHCP = true;
    wireless.enable = false;
  };

  hardware = {
    deviceTree = {
      enable = true;
      filter = "bcm2711-rpi-4*.dtb";
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  sound.enable = false;

  system.stateVersion = "23.11";
}
