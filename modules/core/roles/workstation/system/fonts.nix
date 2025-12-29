{ config, pkgs, ... }:
let
  fontPkg = pkgs.iosevka-bin.override { variant = "SGr-IosevkaTerm"; };

  font = config.modules.system.font;
in
{
  modules.system.font = {
    monospace = {
      family = "Iosevka Term Light";
      package = fontPkg;
    };
    regular = {
      family = "Iosevka Term Extended Medium";
      package = fontPkg;
    };
  };

  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
    };

    packages = with pkgs; [
      font.monospace.package
      font.regular.package
      nerd-fonts.iosevka-term

      kdePackages.kcharselect
    ];
  };
}
