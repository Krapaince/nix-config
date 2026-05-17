{
  lib,
  osConfig,
  pkgs,
  self',
  ...
}:
let
  toLua = lib.generators.toLua;
  inherit (lib) getExe getExe' mkIf;
  inherit (pkgs) writeShellApplication;

  env = osConfig.modules.usrEnv;

  lock = getExe self'.packages.lock-script;

  table = toLua { } {
    fontFamily = osConfig.modules.system.font.monospace.family;

    script = {
      lock = lock;
      suspend = "${lock} -f && ${getExe self'.packages.suspend-script}";
      pipewireControl = getExe pkgs.polybar-pulseaudio-control;
      screenshot = getExe (writeShellApplication {
        name = "screenshot";
        text = "slurp | grim -g - - | wl-copy";
        runtimeInputs = with pkgs; [
          slurp
          grim
          wl-clipboard
        ];
      });
      screenshotEdit = getExe (writeShellApplication {
        name = "screenshot-edit";
        text = "slurp | grim -g - - | satty --filename - --copy-command wl-copy --early-exit";
        runtimeInputs = with pkgs; [
          slurp
          grim
          satty
        ];
      });
    };
    program = {
      alacritty = getExe pkgs.alacritty;
      brightnessctl = getExe pkgs.brightnessctl;
      pactl = getExe' pkgs.pulseaudio "pactl";
      playerctl = getExe pkgs.playerctl;
      "swaync-client" = getExe' pkgs.swaynotificationcenter "swaync-client";
      rofi = getExe pkgs.rofi;
      tmux = getExe pkgs.tmux;
    };
  };
in
{
  config = mkIf env.wms.hyprland.enable {
    xdg.configFile."hypr/nix.lua".text = ''
      return ${table}
    '';
  };
}
