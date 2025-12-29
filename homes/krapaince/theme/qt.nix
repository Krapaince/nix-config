{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep mkIf mkMerge;

  inherit (lib.custom) mkThemeSwitchHookConf;
  sys = osConfig.modules.system;

  cfg = osConfig.modules.style.qt;
  font = sys.font;

  dark = cfg.kvantum.theme.dark;
  light = cfg.kvantum.theme.light;

  themedApps = [
    "hyprland-share-picker"
    "info.mumble.Mumble"
    "krita"
    "org.kde.dolphin"
    "qt5ct"
    "qt6ct"
  ];

  qtctFontsSection = ''
    [Fonts]
    general="${font.regular.family},10,-1,5,500,0,0,0,0,0,0,0,0,0,0,1,Regular"
    fixed="${font.monospace.family},10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
  '';
in

{
  config = mkIf sys.video.enable (mkMerge [
    {
      qt = {
        enable = true;
        platformTheme.name = "qt6ct";
        style.name = "kvantum";
      };

      home = {
        packages = with pkgs; [
          # Libraries and programs to ensure
          # that QT applications load without issues, e.g. missing libs.
          libsForQt5.qt5.qtwayland # qt5
          kdePackages.qtwayland # qt6
          qt6.qtwayland
          kdePackages.qqc2-desktop-style

          # qt5ct/qt6ct for configuring QT apps imperatively
          libsForQt5.qt5ct
          kdePackages.qt6ct

          # Some KDE applications such as Dolphin try to fall back to Breeze
          # theme icons. Lets make sure they're also found.
          kdePackages.breeze
          kdePackages.breeze-icons
          qt6.qtsvg # needed to load breeze icons

          cfg.kvantum.theme.light.package
          cfg.kvantum.theme.dark.package
        ];

        sessionVariables = {
          # Scaling factor for QT applications. 1 means no scaling
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";

          QT_QPA_PLATFORM = "wayland;xcb";

          # Disable QT specific window decorations everywhere
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        };
      };

      xdg.configFile = {
        "Kvantum/${dark.name}".source = "${dark.package}/share/Kvantum/${dark.name}";
        "Kvantum/${light.name}".source = "${light.package}/share/Kvantum/${light.name}";
      };
    }

    (mkThemeSwitchHookConf {
      inherit config pkgs;
      program = "Kvantum";
      themeFilename = "kvantum.kvconfig";
      darkTheme = {
        text = ''
          [General]
          theme=${dark.name}
          [Applications]
          ${dark.name}=${concatStringsSep "," themedApps}
        '';
      };
      lightTheme = {
        text = ''
          [General]
          theme=${light.name}
          [Applications]
          ${light.name}=${concatStringsSep "," themedApps}
        '';
      };
    })

    (mkThemeSwitchHookConf {
      inherit config pkgs;
      program = "qt6ct";
      themeFilename = "qt6ct.conf";
      darkTheme = {
        text = ''
          [Appearance]
          icon_theme=breeze-dark
          style=kvantum
          ${qtctFontsSection}
        '';
      };
      lightTheme = {
        text = ''
          [Appearance]
          icon_theme=breeze-light
          style=kvantum
          ${qtctFontsSection}
        '';
      };
    })

    (mkThemeSwitchHookConf {
      inherit config pkgs;
      program = "qt5ct";
      themeFilename = "qt5ct.conf";
      darkTheme = {
        text = ''
          [Appearance]
          icon_theme=breeze-dark
          style=kvantum
          ${qtctFontsSection}
        '';
      };
      lightTheme = {
        text = ''
          [Appearance]
          icon_theme=breeze-light
          style=kvantum
          ${qtctFontsSection}
        '';
      };
    })

    # Yipi thank you KDE
    # https://youtu.be/rQHJnBHeFhQ?si=gFa6mpvrlMLFssKL&t=465
    (mkThemeSwitchHookConf {
      inherit config pkgs;
      program = "kde";
      themeFilepath = "${config.xdg.configHome}/kdeglobals";
      darkTheme = {
        text = ''
          [UiSettings]
          ColorScheme=BreezeDark
        '';
      };
      lightTheme = {
        text = ''
          [UiSettings]
          ColorScheme=BreezeLight
        '';
      };
    })
  ]);
}
