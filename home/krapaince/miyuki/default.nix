let common_monitors = import ../features/desktop/common/monitors.nix;
in {
  imports = [
    ../core
    ./sops.nix

    ../features/desktop/hyprland
  ];

  monitors = [{
    name = "eDP-1";
    primary = true;
  }] ++ common_monitors.monitors;

  waybar.network-interfaces = {
    wired.name = "enp0s31f6";
    wireless.name = "wlp3s0";
  };
}
