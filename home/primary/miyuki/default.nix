{ pkgs, ... }:
let common_monitors = import ../features/desktop/common/monitors.nix;
in {
  imports = [
    ../core
    ./sops.nix

    ../features/desktop/hyprland
  ];

  home.packages = with pkgs; [ slack strongswan ];

  monitors = [
    {
      name = "eDP-1";
      primary = true;
      x = 3000;
      y = 130;
    }
    {
      name = "desc:Lenovo Group Limited E24-28 VVP43933";
      transform.rotation = 90;
    }
    {
      name = "desc:AOC 27B2G5 RZAN7HA003107";
      x = 1080;
      y = 130;
    }
  ] ++ common_monitors.monitors;

  waybar.network-interfaces = {
    wired.name = "enp5s0";
    wireless.name = "wlp3s0";
  };
}
