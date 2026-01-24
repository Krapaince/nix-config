{
  inputs,
  lib,
  ...
}:
let
  identity = inputs.secrets.identities.personal;
in
{
  imports = [
    ./fs
    ./system
    ./secrets.nix
  ];

  config = {
    modules = {
      device = {
        type = "laptop";
        cpu.type = "intel";
        monitors = [
          {
            name = "eDP-1";
            primary = true;
            x = 5000;
            y = 2000;
          }
        ];
        hasBluetooth = true;
        hasSound = true;
      };
      profiles = {
        gaming.enable = true;
        workstation.enable = true;
      };
      system = {
        mainUser.name = "krapaince";
        filesystem.enabledFilesystems = [
          "vfat"
          "btrfs"
          "ext4"
        ];
        boot.loader = "systemd-boot";
        sound.enable = true;
        video.enable = true;
        bluetooth.enable = true;
        impermanence.enable = true;

        programs = {
          git = {
            email = identity.email;
            signKey = identity.gpg_key;
          };
        };

        networking = {
          interfaces = {
            wired = "enp0s31f6";
            wireless = "wlp3s0";
          };
        };
      };
      usrEnv = {
        wm = "Hyprland";
        useHomeManager = true;

        services.media.mpd.enable = true;
      };
    };

    services.auto-cpufreq.enable = lib.mkForce false;
    networking.networkmanager.enable = true;
    system.stateVersion = "25.11";
  };
}
