{ inputs, configVars, ... }: {
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-t480

    ./disko.nix
    ./hardware-configuration.nix
    ./network-manager-connections.nix

    ../common/global
    ../common/users/${configVars.username}.nix

    ../common/optional/auto-cpufreq.nix
    ../common/optional/bluetooth.nix
    ../common/optional/gnome-keyring.nix
    ../common/optional/pipewire.nix
    ../common/optional/steam.nix
  ];

  networking = {
    hostName = "pabu";
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

  programs = { dconf.enable = true; };

  system.stateVersion = "23.11";
}
