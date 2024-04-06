{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  environment = {
    # etc =
    #   lib.mapAttrs'
    #   (name: value: {
    #     name = "nix/path/${name}";
    #     value.source = value.flake;
    #   })
    #   config.nix.registry;

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
      nil
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
}
