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
      suspend = getExe self'.packages.suspend-script;
      pipewireControl = getExe pkgs.polybar-pulseaudio-control;
      ocr = getExe (writeShellApplication {
        name = "ocr";
        text = ''
          umask 077

          workdir="$(mktemp --directory)"
          # shellcheck disable=SC2064
          trap "rm --recursive --force \"$workdir\"" EXIT
          echo "$workdir"
          input="$workdir/input.png"
          output="$workdir/output"

          slurp | grim -g - "$input"
          tesseract "$input" "$output" -l eng

          wl-copy < "$output.txt"
        '';
        runtimeInputs = with pkgs; [
          coreutils-full
          grim
          slurp
          tesseract
          wl-clipboard
        ];
      });
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
      brightnessctl = getExe pkgs.brightnessctl;
      kitty = getExe pkgs.kitty;
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
