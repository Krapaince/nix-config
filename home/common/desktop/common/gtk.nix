{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ gsettings2 ];

  gtk =
    let
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    in
    {
      enable = true;
      font = {
        name = config.fontProfiles.regular.family;
        size = 8;
      };
      theme = {
        name = "Orchis-Red-Dark";
        package = pkgs.orchis-theme;
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };

      gtk3.extraConfig = extraConfig;
      gtk4.extraConfig = extraConfig;
    };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
