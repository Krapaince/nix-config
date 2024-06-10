{ inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-t480

    ./disko.nix
    ./hardware-configuration.nix
    ./network-manager-connections.nix

    ../common/global
    ../common/users/krapaince.nix

    ../common/optional/auto-cpufreq.nix
    ../common/optional/bluetooth.nix
    ../common/optional/pipewire.nix
  ];

  networking = {
    hostName = "pabu";
    hostId = "a9bf23b0";
    networkmanager.enable = true;
    usePredictableInterfaceNames = true;
  };

  network-interfaces = {
    ethernet = "enp0s31f6";
    wireless = "wlp3s0";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  programs = { dconf.enable = true; };

  system.stateVersion = "23.11";
}
