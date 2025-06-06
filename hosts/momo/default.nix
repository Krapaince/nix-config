{ inputs, lib, ... }: {
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-4

    (lib.custom.relativeToRoot "hosts/common/disks/btrfs.nix")
    {
      _module.args = {
        disk = "/dev/disk/by-id/usb-Argon_Forty_000000000F02-0:0";
        withSwap = true;
        swapSize = 8;
      };
    }

    ./hardware-configuration.nix

    ../common/core
    ../common/users/primary.nix

    ../common/optional/openssh.nix
  ];

  hostSpec.hostName = "momo";

  networking = {
    useDHCP = true;
    wireless.enable = false;
  };

  nix.extraOptions = "pure-eval = false";

  hardware = {
    deviceTree = {
      enable = true;
      filter = "bcm2711-rpi-4*.dtb";
    };
  };
}
