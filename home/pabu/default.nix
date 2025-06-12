{ lib, ... }: {
  imports = lib.flatten [
    (map lib.custom.relativeToHome [
      "common/hyprland.nix"
      "common/desktop/optional/discord.nix"
      "common/desktop/optional/proton-vpn.nix"
      "common/optional/sops.nix"
    ])
  ];

  monitors = [{
    name = "eDP-1";
    primary = true;
  }];

  waybar.network-interfaces = {
    wired.name = "enp0s31f6";
    wireless.name = "wlp3s0";
  };
}
