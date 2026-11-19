{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.custom) isAcceptedDeviceType;

  sys = osConfig.modules.system;
  font = sys.font;
  themes = pkgs.kitty-themes + "/share/kitty-themes/themes";
in
{
  config =
    mkIf ((isAcceptedDeviceType osConfig [ "laptop" ]) && sys.programs.terminals.kitty.enable)
      {
        xdg.configFile."kitty/dark-theme.auto.conf".source = themes + "/rose-pine.conf";
        xdg.configFile."kitty/light-theme.auto.conf".source = themes + "/Dawnfox.conf";

        programs.kitty = {
          enable = true;
          font = {
            name = font.monospace.family;
            size = 10;
          };

          shellIntegration.mode = "no-rc no-cursor";

          settings = {
            background_opacity = 1;
            mouse_hide_wait = -1;
            clear_all_shortcuts = true;
            remember_window_size = "no";
            enable_audio_bell = "no";
          };

          keybindings = {
            "ctrl+shift+c" = "copy_to_clipboard";
            "ctrl+shift+v" = "paste_from_clipboard";
            "ctrl+plus" = "change_font_size all +1.0";
            "ctrl+minus" = "change_font_size all -1.0";
            "super+u" = "scroll_line_down";
            "super+i" = "scroll_line_up";
            "ctrl+page_down" = "scroll_page_down";
            "ctrl+page_up" = "scroll_page_up";
          };
        };
      };
}
