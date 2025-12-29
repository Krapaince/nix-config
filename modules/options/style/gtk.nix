{ lib, pkgs, ... }:
let
  inherit (lib) mkOption types;
  inherit (lib.types) str;

  theme = package: name: {
    package = mkOption {
      type = types.package;
      default = package;
    };
    name = mkOption {
      type = str;
      default = name;
    };
  };
in
{
  options.modules.style.gtk = {
    theme = {
      dark = theme pkgs.orchis-theme "Orchis-Red-Dark";
      light = theme pkgs.orchis-theme "Orchis-Red-Light";
    };

    iconTheme = {
      dark = theme pkgs.papirus-icon-theme "Papirus-Dark";
      light = theme pkgs.papirus-icon-theme "Papirus-Light";
    };
  };
}
