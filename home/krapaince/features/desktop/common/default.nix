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
  ];

  home.packages = with pkgs; [ xdg-utils ];

  xdg.portal = {
    enable = true;
    # https://github.com/NixOS/nixpkgs/issues/160923
    xdgOpenUsePortal = true;
  };
}
