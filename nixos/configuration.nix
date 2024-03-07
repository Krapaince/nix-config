{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment = {
    etc =
      lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

    systemPackages = with pkgs; [
      bat
      btop
      cmake
      delta
      firefox
      fzf
      gcc
      git
      gitui
      gnumake
      grim
      htop
      hyprland
      iosevka
      killall
      kitty
      man
      man-pages
      neovim
      networkmanagerapplet
      pavucontrol
      pipewire
      ripgrep
      vifm
      waybar
      wezterm
      wl-clipboard
      wofi
      xdg-desktop-portal
      xdg-desktop-portal-hyprland
    ];
  };

  fonts = {
    packages = with pkgs; [
      iosevka
    ];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
    };

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = ["/etc/nix/path"];

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  system.stateVersion = "23.11";

  time.timeZone = "Europe/Paris";

  users.users = {
    krapaince = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
    };
  };
}
