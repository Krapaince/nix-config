{ config, ... }: {
  xdg.mimeApps = {
    associations.added = { "x-scheme-handler/terminal" = "kitty.desktop"; };
    defaultApplications = { "x-scheme-handler/terminal" = "kitty.desktop"; };
  };

  programs.kitty = {
    enable = true;

    extraConfig = let font_family = config.fontProfiles.monospace.family;
    in ''
      font_family ${font_family} Light
      font_size 9
      bold_font ${font_family} Heavy
      italic_font ${font_family} Light Oblique
      bold_italic_font ${font_family} Heavy Oblique
    '';

    settings = {
      disable_ligatures = "never";
      box_drawing_scale = "0.001, 1, 1.5, 2";

      # Cursor customization
      shell_integration = "no-cursor";
      cursor = "#52ad80";
      cursor_text_color = "#000000";
      cursor_shape = "block";
      cursor_blink_interval = 0;

      # Scrollback
      scrollback_lines = 5000;

      # Mouse
      mouse_hide_wait = "3.0";
      url_color = "#0087bd";
      url_style = "curly";
      copy_on_select = "clipboard";

      strip_trailing_spaces = "never";

      focus_follows_mouse = "no";

      # Terminal bell
      enable_audio_bell = "no";
      visual_bell_duration = "0.0";
      window_alert_on_bell = "yes";
      bell_on_tab = "no";
      command_on_bell = "none";

      # Window layout
      enabled_layouts = "splits:split_axis=horizontal";
      window_resize_step_cells = 2;
      window_resize_step_lines = 2;

      window_border_width = "1.0";

      draw_minimal_borders = "yes";

      active_border_color = "#bf8300";
      inactive_border_color = "#cccccc";

      bell_border_color = "#ff5a00";

      # Tab bar
      tab_bar_edge = "top";
      tab_bar_style = "fade";
      tab_fade = "0.33 0.80";
      tab_separator = " |";
      tab_title_template = "{index} {title[title.rfind('/')+1:]}";

      active_tab_foreground = "#000";
      active_tab_background = "#eee";
      active_tab_font_style = "bold-italic";
      inactive_tab_foreground = "#444";
      inactive_tab_background = "#999";
      inactive_tab_font_style = "normal";

      # Color sheme
      foreground = "#dddddd";
      background = "#000000";

      background_opacity = "0.9";
      dynamic_background_opacity = "yes";
      dim_opacity = "0.75";

      selection_foreground = "#000000";

      selection_background = "#fffacd";

      update_check_interval = 0;
    };

    keybindings = let mod = "super";
    in {
      # Scrolling
      "${mod}+i" = "scroll_line_up";
      "${mod}+u" = "scroll_line_down";
      "${mod}+page_up" = "scroll_page_up";
      "${mod}+page_down" = "scroll_page_down";
      "${mod}+home" = "scroll_home";
      "${mod}+end" = "scroll_end";

      # Window management
      "ctrl+enter" = "launch --cwd=current --location=hsplit";
      "ctrl+alt+enter" = "launch --cwd=current --location=vsplit";
      "${mod}+shift+r" = "swap_with_window";

      "ctrl+shift+h" = "resize_window narrower";
      "ctrl+shift+l" = "resize_window wider";
      "ctrl+shift+j" = "resize_window shorter";
      "ctrl+shift+k" = "resize_window taller";

      # New kitty window
      "${mod}+w" = "close_window";

      "${mod}+h" = "neighboring_window left";
      "${mod}+k" = "neighboring_window up";
      "${mod}+j" = "neighboring_window down";
      "${mod}+l" = "neighboring_window right";

      "${mod}+r" = "start_resizing_window";

      # Tab management
      "${mod}+shift+l" = "next_tab";
      "${mod}+shift+h" = "previous_tab";
      "${mod}+shift+t" = "launch --cwd=current --type=tab --location after";
      "${mod}+shift+q" = "close_tab";
      "${mod}+." = "move_tab_forward";
      "${mod}+," = "move_tab_backward";
      "${mod}+alt+t" = "set_tab_title";

      # Font sizes
      "ctrl+shift+equal" = "change_font_size all +2.0";
      "ctrl+shift+minus" = "change_font_size all -2.0";
      "${mod}+backspace" = "change_font_size all 0";

      # Miscellaneous
      "${mod}+a>m" = "set_background_opacity +0.1";
      "${mod}+a>l" = "set_background_opacity -0.1";
      "${mod}+a>1" = "set_background_opacity 1";
      "${mod}+a>d" = "set_background_opacity default";
    };
  };
}
