{ lib, pkgs, ... }:
let
  catppuccinAccent = "Red";
  catppuccinFlavor = "Macchiato";
  catppuccinKvantum = pkgs.catppuccin-kvantum.override {
    accent = lib.toLower catppuccinAccent;
    variant = lib.toLower catppuccinFlavor;
  };
  themeName = "catppuccin-${lib.toLower catppuccinFlavor}-${
      lib.toLower catppuccinAccent
    }";
in {
  home.packages = [ catppuccinKvantum ];

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/${themeName}".source =
      "${catppuccinKvantum}/share/Kvantum/${themeName}";
    "Kvantum/kvantum.kvconfig".source =
      (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
        General.theme = themeName;
      };
  };
}
