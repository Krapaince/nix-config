{ pkgs, ... }: {
  imports = [
    ./firefox.nix
    ./font.nix
    ./gtk.nix
    ./kitty
    ./network-manager-applet.nix
    ./pavucontrol.nix
    ./playerctl.nix
    ./qt.nix
    ./rofi.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    chromium
    gimp
    imv
    krita
    mumble
    pinta
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
