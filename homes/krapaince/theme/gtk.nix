{
  lib,
  pkgs,
  osConfig,
  self',
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.custom) mkThemeSwitchHook;
  sys = osConfig.modules.system;

  cfg = osConfig.modules.style.gtk;
  font = osConfig.modules.system.font;
in
{
  config = mkIf sys.video.enable {
    home = {
      packages = with pkgs; [
        self'.packages.gsettings2
        gnome-tweaks
        dconf-editor
      ];
    };

    # Pavucontrol doesn't follow the GTK theme when switching theme
    # https://gitlab.freedesktop.org/pulseaudio/pavucontrol/-/issues/159#note_2502390
    gtk = {
      enable = true;
      font = {
        name = font.regular.family;
        size = 8;
      };
      theme = {
        inherit (cfg.theme.dark) name package;
      };
      iconTheme = {
        inherit (cfg.iconTheme.dark) name package;
      };
    };

    theme.switch.hooks = [
      (mkThemeSwitchHook {
        inherit pkgs;
        program = "gtk";
        runtimeInputs = [ self'.packages.gsettings2 ];
        text = /* bash */ ''
          if [[ "$1" == "dark" ]]; then
            gsettings2 set org.gnome.desktop.interface gtk-theme '${cfg.theme.dark.name}'
            gsettings2 set org.gnome.desktop.interface icon-theme '${cfg.iconTheme.dark.name}'
          else
            gsettings2 set org.gnome.desktop.interface gtk-theme '${cfg.theme.light.name}'
            gsettings2 set org.gnome.desktop.interface icon-theme '${cfg.iconTheme.light.name}'
          fi
        '';
      })
    ];
  };
}
