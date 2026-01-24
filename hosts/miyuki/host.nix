{ inputs, ... }:
let
  identidy = inputs.secrets.identities.work;
in
{
  imports = [
    ./fs
    ./system
    ./secrets.nix

    (inputs.nix-config-work + "/hosts/miyuki")
  ];

  config = {
    modules = {
      device = {
        type = "laptop";
        cpu.type = "amd";
        monitors = [
          {
            name = "eDP-1";
            primary = true;
            x = 5000;
            y = 2000;
          }
          {
            name = "desc:Lenovo Group Limited E24-28 VVP43933";
            relativeTo = "desc:AOC 27B2G5 RZAN7HA003107";
            direction = "west";
            transform.rotation = 90;
            offsetY = -200;
          }
          {
            name = "desc:AOC 27B2G5 RZAN7HA003107";
            relativeTo = "eDP-1";
            direction = "west";
          }
        ];
        hasBluetooth = true;
        hasSound = true;
      };
      profiles = {
        workstation.enable = true;
      };
      system = {
        mainUser = {
          name = "mpointec";
          import = "krapaince";
        };
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
            email = identidy.email;
            signKey = identidy.gpg_key;
          };
        };

        networking = {
          interfaces = {
            wired = "enp5s0";
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

    networking.networkmanager.enable = true;
    system.stateVersion = "25.11";
  };
}
