{
  imports = [
    ./fs
  ];

  modules = {
    device = {
      type = "server";
      cpu.type = "amd";
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
      boot.loader = "systemd-boot";
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

  system.stateVersion = "26.11";
}
