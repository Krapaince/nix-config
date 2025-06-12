{ inputs, lib, ... }: {
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2

    (lib.custom.relativeToRoot "hosts/common/disks/btrfs.nix")
    {
      _module.args = {
        disk = "/dev/disk/by-id/nvme-SKHynix_HFS512GDE9X081N_FYB3N016713803B2K";
        withSwap = true;
        swapSize = 24;
      };
    }

    ./hardware-configuration.nix
    ./network-manager-connections.nix
    ./vpn.nix

    ../common/core
    ../common/users/primary.nix

    ../common/optional/auto-cpufreq.nix
    ../common/optional/bluetooth.nix
    ../common/optional/gnome-keyring.nix
    ../common/optional/pipewire.nix
  ];

  hostSpec = {
    hostName = "miyuki";
    identity = lib.mkForce inputs.secrets.identities.work;
    isWork = true;
    username = lib.mkForce "mpointec";
  };

  networking = {
    networkmanager = {
      enable = true;
      enableStrongSwan = true;
    };
  };

  network-interfaces = {
    ethernet = "enp5s0";
    wireless = "wlp3s0";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs = { dconf.enable = true; };
}
