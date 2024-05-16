{ pkgs, ... }:

{
  home.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "IosevkaTerm" ]; }) ];

  fontProfiles = {
    enable = true;
    monospace = {
      family = "IosevkaTerm Light";
      package = pkgs.iosevka-bin.override { variant = "SGr-IosevkaTerm"; };
    };
    regular = {
      family = "Iosevka Term Extended Medium";
      package = pkgs.iosevka-bin.override { variant = "SGr-IosevkaTerm"; };
    };
  };
}
