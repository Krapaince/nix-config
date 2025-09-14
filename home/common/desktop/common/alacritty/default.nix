{
  config,
  pkgs,
  lib,
  ...
}:
let
  fontFamilly = config.fontProfiles.monospace.family;
in
{
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

  xdg.configFile."alacritty/dark-theme.toml".source =
    pkgs.alacritty-theme + "/share/alacritty-theme/rose_pine.toml";
  xdg.configFile."alacritty/light-theme.toml".source =
    pkgs.alacritty-theme + "/share/alacritty-theme/dawnfox.toml";

  switchTheme.hooks = lib.lists.optionals config.programs.alacritty.enable (
    let
      name = "switch-theme-alacritty";
    in
    [
      (lib.getExe (
        pkgs.writeShellApplication {
          inherit name;
          runtimeInputs = [ pkgs.coreutils ];
          text = builtins.readFile ./switch-theme.sh;
          meta.mainProgram = name;
        }
      ))
    ]
  );
}
