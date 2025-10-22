{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  dragon = lib.getExe pkgs.xdragon;
  flavor = builtins.toString inputs.yazi-flavor;
  theme = lib.custom.switchThemeScript {
    inherit pkgs;
    program = "yazi";
    themeFilename = "theme.toml";
    darkThemeSource = flavor + "/catppuccin-mocha.yazi/flavor.toml";
    lightThemeSource = flavor + "/catppuccin-latte.yazi/flavor.toml";
    enable = config.programs.yazi.enable;
  };
in
lib.recursiveUpdate theme {
  home.packages = with pkgs; [ ueberzugpp ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    keymap = {
      mgr = {
        prepend_keymap = [
          {
            on = [ "<C-n>" ];
            run = ''
              shell '${dragon} -x -T "$1"' --confirm
            '';
          }
        ];
      };
    };
    settings = {
      sorting = {
        sort_by = "natural";
        sort_sensitive = false;
        show_hidden = true;
      };
      opener = {
        text = [
          {
            run = ''nvim "$@"'';
            block = true;
          }
        ];
        image = [
          {
            run = ''imv "$@"'';
            orphan = true;
          }
        ];
        pdf = [
          {
            run = ''zathura "$@"'';
            orphan = true;
          }
        ];
      };
      open = {
        rules = [
          {
            mime = "text/*";
            use = "text";
          }
          {
            mime = "image/*";
            use = "image";
          }
          {
            name = "*.pdf";
            use = "pdf";
          }
        ];

      };
    };
  };
}
