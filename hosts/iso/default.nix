# A minimal ISO image to bootstrap an host.
{
  pkgs,
  modulesPath,
  lib,
  ...
}:
let
  keys = lib.lists.forEach [ ./id_iso.pub ] (key: builtins.readFile key);
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce [
      "btrfs"
      "vfat"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      git
      disko
      neovim
    ];
  };

  # The default compression-level is (6) and takes too long on some machines (>30m). 3 takes <2m
  isoImage.squashfsCompression = "zstd -Xcompression-level 3";

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];
  networking = {
    hostName = "iso";
    networkmanager.enable = true;
    wireless.enable = false;
  };

  programs.fish.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  systemd = {
    services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = keys;
    shell = pkgs.fish;
  };
  users.users.nixos = {
    openssh.authorizedKeys.keys = keys;
    shell = pkgs.fish;
  };

}
