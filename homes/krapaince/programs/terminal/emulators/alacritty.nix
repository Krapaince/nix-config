{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (lib.custom) isAcceptedDeviceType mkThemeSwitchHookConf;

  sys = osConfig.modules.system;
  font = sys.font;

  theme = mkThemeSwitchHookConf {
    inherit config pkgs;
    program = "alacritty";
    themeFilename = "theme.toml";
    darkTheme = {
      source = pkgs.alacritty-theme + "/share/alacritty-theme/rose_pine.toml";
    };
    lightTheme = {
      source = pkgs.alacritty-theme + "/share/alacritty-theme/dawnfox.toml";
    };
    enable = config.programs.alacritty.enable;
  };
in
{
  config =
    mkIf ((isAcceptedDeviceType osConfig [ "laptop" ]) && sys.programs.terminals.alacritty.enable)
      (mkMerge [
        theme
        {
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
                  family = font.monospace.family;
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
      ]);
}
