{ pkgs, lib, ... }:
let
  inherit (lib) types;
  inherit (lib.options) mkOption;

  kvantumTheme = package: name: {
    package = mkOption {
      type = types.package;
      default = package;
      description = "Path to the kvantum theme package to be used for QT programs.";
    };
    name = mkOption {
      type = types.str;
      default = name;
    };
  };

  kvantumThemePackage =
    accent: variant:
    pkgs.catppuccin-kvantum.override {
      inherit accent variant;
    };

  darkFlavor = "macchiato";
  lightFlavor = "latte";
  accent = "red";
in
{
  options.modules.style.qt = {
    kvantum.theme = {
      dark = kvantumTheme (kvantumThemePackage accent darkFlavor) "catppuccin-${darkFlavor}-${accent}";
      light = kvantumTheme (kvantumThemePackage accent lightFlavor) "catppuccin-${lightFlavor}-${accent}";
    };
  };
}
