{
  config,
  pkgs,
  lib,
  ...
}:
let
  dragon = lib.getExe pkgs.xdragon;
  flavors =
    (fetchGit {
      url = "https://github.com/yazi-rs/flavors";
      rev = "2d73b79da7c1a04420c6c5ef0b0974697f947ef6";
      shallow = true;
    }).outPath;
  theme = lib.custom.switchThemeScript {
    inherit pkgs;
    program = "yazi";
    themeFilename = "theme.toml";
    darkThemeSource = flavors + "/catppuccin-mocha.yazi/flavor.toml";
    lightThemeSource = flavors + "/catppuccin-latte.yazi/flavor.toml";
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
            run = ''${lib.getExe pkgs.neovim} "$@"'';
            block = true;
          }
        ];
        image = [
          {
            run = ''${lib.getExe pkgs.imv} "$@"'';
            orphan = true;
          }
        ];
        pdf = [
          {
            run = ''${lib.getExe pkgs.zathura} "$@"'';
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
