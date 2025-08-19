{ inputs, lib, ... }:
{
  imports = lib.flatten [
    (map lib.custom.relativeToHome [
      "common/hyprland.nix"
      "common/optional/sops.nix"
    ])

    ./scripts/change-slack-pp.nix
    (inputs.nix-config-work + "/home/miyuki/default.nix")
  ];

  monitors = [
    {
      name = "eDP-1";
      primary = true;
      x = 5000;
      y = 2000;
    }
    {
      name = "desc:Lenovo Group Limited E24-28 VVP43933";
      relativeTo = "desc:AOC 27B2G5 RZAN7HA003107";
      direction = "west";
      transform.rotation = 90;
      offsetY = -200;
    }
    {
      name = "desc:AOC 27B2G5 RZAN7HA003107";
      relativeTo = "eDP-1";
      direction = "west";
    }
  ];

  waybar.network-interfaces = {
    wired.name = "enp5s0";
    wireless.name = "wlp3s0";
  };
}
