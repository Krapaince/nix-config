{ lib, ... }:
let
  common_monitors =
    import (lib.custom.relativeToHome "common/desktop/common/monitors.nix");
in {
  imports = lib.flatten [
    ./sops.nix

    (map lib.custom.relativeToHome [
      "common"
      "common/desktop/hyprland"

      "common/desktop/optional/discord.nix"
      "common/desktop/optional/proton-vpn.nix"
    ])
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
