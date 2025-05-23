{ inputs, configVars, ... }: {
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-4

    ./disko.nix
    ./hardware-configuration.nix

    ../common/global
    ../common/users/${configVars.username}.nix

    ../common/optional/openssh.nix
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

  system.stateVersion = "23.11";
}
