{ config, ... }:
let
  browser = [ "firefox.desktop" ];
  terminal = [ "Alacritty.desktop" ];

  homeDir = config.home.homeDirectory;

  associations = {
    "text/html" = browser;
    "text/xml" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-schema-handler/terminal" = terminal;
  };
in
{
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = homeDir + "/Desktop";
      documents = homeDir + "/Documents";
      download = homeDir + "/Downloads";
      music = homeDir + "/Music";
      pictures = homeDir + "/Pictures";
      publicShare = null;
      templates = null;
      videos = homeDir + "/Videos";
    };

    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
