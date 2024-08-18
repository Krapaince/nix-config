{ pkgs, ... }: {
  imports = [
    ./firefox.nix
    ./font.nix
    ./gtk.nix
    ./kitty.nix
    ./network-manager-applet.nix
    ./pavucontrol.nix
    ./playerctl.nix
    ./rofi.nix
    ./wezterm
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    gimp
    imv
    krita
    vlc
    wdisplays
    xdg-utils
    xdragon
    zeal
  ];

  xdg.portal = {
    enable = true;
    # https://github.com/NixOS/nixpkgs/issues/160923
    xdgOpenUsePortal = true;
  };
}
