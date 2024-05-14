{ ... }: {
  imports = [
    ./firefox.nix
    ./kitty.nix
    ./pavucontrol.nix
    ./playerctl.nix
    ./rofi.nix
    ./wezterm
  ];

  xdg.portal.enable = true;
}
