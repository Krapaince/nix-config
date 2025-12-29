{
  config,
  lib,
  pkgs,
  osConfig,
  self',
  ...
}:
let
  inherit (lib)
    findFirst
    getExe
    mkForce
    mkIf
    ;
  env = osConfig.modules.usrEnv;
  monitors = osConfig.modules.device.monitors;

  primaryScreen = (findFirst (m: m.primary) null monitors).name;
  homeDir = config.home.homeDirectory;
  wallpaperDir = homeDir + "/Pictures/wallpapers";
  wallpapers = self'.packages.wallpapers;
in
{
  config = mkIf env.wms.hyprland.enable {
    services.wpaperd = {
      enable = true;
      settings = {
        "${primaryScreen}" = {
          duration = "60s";
          path = "${wallpaperDir}/${primaryScreen}";
          sorting = "ascending";
        };
        any = {
          path = "${wallpaperDir}/any";
          duration = "1h";
        };
      };
    };

    systemd.user.services.wpaperd = {
      Service = {
        ExecStart = mkForce (
          getExe (
            pkgs.writeShellApplication {
              # TODO: Maybe move this to a dedicated service
              name = "wallpaper";
              runtimeInputs = with pkgs; [
                self'.packages.wall-gen
                wpaperd
                coreutils
              ];
              text = ''
                mkdir -p "${wallpaperDir}/${primaryScreen}" "${wallpaperDir}/any"

                install -m 644 "${wallpapers}/"* "${wallpaperDir}/any"
                rm "${wallpaperDir}/any/avatar.png"

                wall-gen --color-set "${./color-set.json}" --output "${wallpaperDir}/${primaryScreen}" -w "${wallpapers}/avatar.png"

                wpaperd
              '';
            }
          )
        );
      };
    };
  };
}
