{ pkgs, ... }:

{
  home.packages = with pkgs; [ nerd-fonts.iosevka-term ];

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
