{ inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-t480

    ./hardware-configuration.nix

    ../common/global
    ../common/users/krapaince.nix

    ../common/optional/pipewire.nix
  ];

  networking = {
    hostName = "pabu";
    networkmanager.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  system.stateVersion = "23.11";
}
