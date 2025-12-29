{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib)
    flatten
    getExe
    mkIf
    mkMerge
    optionals
    ;
  inherit (lib.custom) mkThemeSwitchHookConf;

  prg = config.programs;
  sys = osConfig.modules.system;

  dragon = getExe pkgs.xdragon;
  flavors =
    (fetchGit {
      url = "https://github.com/yazi-rs/flavors";
      rev = "2d73b79da7c1a04420c6c5ef0b0974697f947ef6";
      shallow = true;
    }).outPath;
  theme = mkThemeSwitchHookConf {
    inherit config pkgs;
    program = "yazi";
    themeFilename = "theme.toml";
    darkTheme = {
      source = flavors + "/catppuccin-mocha.yazi/flavor.toml";
    };
    lightTheme = {
      source = flavors + "/catppuccin-latte.yazi/flavor.toml";
    };
    enable = config.programs.yazi.enable;
  };
in
mkMerge [
  theme
  {
    home.packages = with pkgs; [ ueberzugpp ];

    programs.yazi = {
      enable = true;
      enableFishIntegration = prg.fish.enable;
      keymap = {
        mgr = {
          prepend_keymap = flatten [
            (optionals sys.video.enable [
              {
                on = [ "<C-n>" ];
                run = ''
                  shell '${dragon} -x -T "$1"' --confirm
                '';
              }
            ])
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
              run = ''${getExe pkgs.neovim} "$@"'';
              block = true;
            }
          ];
          image = mkIf sys.video.enable [
            {
              run = ''${getExe pkgs.imv} "$@"'';
              orphan = true;
            }
          ];
          pdf = mkIf sys.video.enable [
            {
              run = ''${getExe pkgs.zathura} "$@"'';
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
]
