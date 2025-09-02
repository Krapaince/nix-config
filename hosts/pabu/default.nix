{ inputs, lib, ... }:
{
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-t480

    (lib.custom.relativeToRoot "hosts/common/disks/btrfs.nix")
    {
      _module.args = {
        disk = "/dev/disk/by-id/wwn-0x5001b448b876d9a3";
        withSwap = true;
        swapSize = 16;
      };
    }

    ./hardware-configuration.nix
    ./network-manager-connections.nix

    ../common/core
    ../common/users/primary.nix

    ../common/optional/auto-cpufreq.nix
    ../common/optional/bluetooth.nix
    ../common/optional/gnome-keyring.nix
    ../common/optional/pipewire.nix
    ../common/optional/steam.nix
  ];

  hostSpec = {
    hostName = "pabu";
    backlight = "intel_backlight";
  };

  networking = {
    networkmanager.enable = true;
    usePredictableInterfaceNames = true;
  };

  network-interfaces = {
    ethernet = "enp0s31f6";
    wireless = "wlp3s0";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs = {
    dconf.enable = true;
  };

  services.auto-cpufreq.enable = false;
}
