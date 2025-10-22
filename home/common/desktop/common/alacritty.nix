{
  config,
  pkgs,
  lib,
  ...
}:
let
  fontFamilly = config.fontProfiles.monospace.family;
  theme = lib.custom.switchThemeScript {
    inherit pkgs;
    program = "alacritty";
    themeFilename = "theme.toml";
    darkThemeSource = pkgs.alacritty-theme + "/share/alacritty-theme/rose_pine.toml";
    lightThemeSource = pkgs.alacritty-theme + "/share/alacritty-theme/dawnfox.toml";
    enable = config.programs.alacritty.enable;
  };
in
lib.recursiveUpdate theme {
  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/terminal" = "Alacritty.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/terminal" = "Alacritty.desktop";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = [
          "~/.config/alacritty/theme.toml"
        ];
      };
      window = {
        opacity = 0.9;
        dynamic_title = true;
      };

      font = {
        normal = {
          family = fontFamilly;
          style = "Regular";
        };
        size = 10;
      };

      mouse = {
        hide_when_typing = true;
      };

      keyboard.bindings =
        let
          bindAction = mods: key: action: { inherit mods key action; };
        in
        [
          (bindAction "Control" "+" "IncreaseFontSize")
          (bindAction "Control" "-" "DecreaseFontSize")
          (bindAction "Super" "u" "ScrollLineDown")
          (bindAction "Super" "i" "ScrollLineUp")
          (bindAction "Control" "PageDown" "ScrollPageDown")
          (bindAction "Control" "PageUp" "ScrollPageUp")
        ];
    };
  };
}
