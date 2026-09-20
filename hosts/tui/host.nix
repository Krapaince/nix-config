{
  config,
  keys,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  authorizedKeys = [
    keys.users.miyuki.mpointec
    keys.users.pabu.krapaince
  ];

  mountpoint = "/mnt";
  impermanence = config.modules.system.impermanence;
in
{
  imports = [
    "${modulesPath}/installer/netboot/netboot-minimal.nix"
  ];

  config = {
    modules = {
      device.type = "netboot";

      system = {
        boot.loader = "systemd-boot";
        sound.enable = false;
        video.enable = false;
        bluetooth.enable = false;
        impermanence.enable = false;
        services.sshd.enable = true;
        programs = {
          gui.enable = false;
          cli.enable = false;
        };
      };

      usrEnv.useHomeManager = false;
    };

    environment = {
      systemPackages = with pkgs; [
        age
        bat
        git
        neovim
        sops
        ssh-to-age
      ];
      variables = {
        SEED_SCRIPT_MOUNTPOINT = mountpoint;
        SEED_SCRIPT_PERSIST = mountpoint + impermanence.mountpoint + "/system";
      };
    };

    security.sudo.extraConfig = ''
      Defaults env_keep += "SEED_SCRIPT_MOUNTPOINT SEED_SCRIPT_PERSIST"
    '';

    # The default compression-level is (6) and takes too long on some machines (>30m). 3 takes <2m
    # isoImage.squashfsCompression = "zstd -Xcompression-level 3";
    netboot.squashfsCompression = "zstd -Xcompression-level 3";

    networking.wireless.enable = lib.mkForce false;

    systemd.tmpfiles.rules = [
      "C /home/nixos/format-disk        0755 nixos users - ${./scripts/format-disk}"
      "C /home/nixos/setup-opt-in-state 0755 nixos users - ${./scripts/setup-opt-in-state}"
    ];

    users.users.nixos = {
      openssh.authorizedKeys.keys = authorizedKeys;
      shell = pkgs.fish;
    };

    system.stateVersion = "26.11";
  };
}
