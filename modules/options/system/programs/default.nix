{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption types;

  sys = config.modules.system;
in
{
  imports = [
    ./gaming.nix
  ];

  options.modules.system.programs = {
    gui.enable = mkEnableOption "GUI package sets" // {
      default = true;
    };
    cli.enable = mkEnableOption "CLI package sets" // {
      default = true;
    };
    dev.enable = mkEnableOption "development related package sets";

    discord.enable = mkEnableOption "Discord";
    protonvpn.enable = mkEnableOption "Proton VPN";
    steam.enable = mkEnableOption "Steam";
    zathura.enable = mkEnableOption "zathura";

    chromium.enable = mkEnableOption "chromium";
    firefox.enable = mkEnableOption "Firefox";

    editors = {
      neovim.enable = mkEnableOption "Neovim" // {
        default = true;
      };
    };

    terminals = {
      alacritty.enable = mkEnableOption "Alacritty";
    };

    git = {
      name = mkOption {
        type = types.str;
        default = sys.mainUser.name;
        description = "Name used for git identity";
      };
      email = mkOption {
        type = types.str;
        default = "";
        description = "Email used for git identity";
      };
      signKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The default gpg key used to sign commits";
      };
    };

    default = {
      browser = mkOption {
        type = types.enum [
          "chromium"
          "firefox"
        ];
        default = "firefox";
      };

      editor = mkOption {
        type = types.enum [ "neovim" ];
        default = "neovim";
      };

      launcher = mkOption {
        type = types.enum [ "rofi" ];
        default = "rofi";
      };

      terminal = mkOption {
        type = types.enum [ "alacritty" ];
        default = "alacritty";
      };
    };
  };
}
