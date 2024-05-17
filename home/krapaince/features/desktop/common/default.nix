{ ... }: {
  imports = [
    ./firefox.nix
    ./font.nix
    ./gtk.nix
    ./kitty.nix
    ./pavucontrol.nix
    ./playerctl.nix
    ./rofi.nix
    ./wezterm
  ];

  xdg.portal.enable = true;
}
