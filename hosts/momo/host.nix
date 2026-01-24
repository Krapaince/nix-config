{ inputs, pkgs, ... }:
let
in
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-4

    ./fs
    ./hardware-configuration.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];

    modules = {
      device = {
        type = "server";
        cpu.type = "pi";
        hasBluetooth = false;
        hasSound = false;
      };
      system = {
        mainUser.name = "krapaince";
        filesystem.enabledFilesystems = [
          "vfat"
          "btrfs"
          "ext4"
        ];
        boot.loader = "none";
        sound.enable = false;
        video.enable = false;
        bluetooth.enable = false;
        impermanence.enable = true;

        programs = {
          gui.enable = false;
        };
      };
      usrEnv = {
        wm = "none";
        useHomeManager = true;
      };
    };

    networking = {
      useDHCP = true;
      wireless.enable = false;
    };

    hardware = {
      deviceTree.enable = true;
    };

    nix.extraOptions = "pure-eval = false";

    system.stateVersion = "25.11";
  };
}
