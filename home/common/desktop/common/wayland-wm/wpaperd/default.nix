{
  config,
  lib,
  pkgs,
  ...
}:
let
  primaryScreen = (lib.findFirst (m: m.primary) null config.monitors).name;
  homeDir = config.home.homeDirectory;
  wallpaperDir = homeDir + "/Pictures/wallpapers";
in
{
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
      ExecStart = lib.mkForce (
        lib.getExe (
          pkgs.writeShellApplication {
            # TODO: Maybe move this to a dedicated service
            name = "wallpaper";
            runtimeInputs = with pkgs; [
              wall-gen
              wpaperd
              coreutils
            ];
            text = ''
              mkdir -p "${wallpaperDir}/${primaryScreen}" "${wallpaperDir}/any"

              install -m 644 "${pkgs.wallpapers}/"* "${wallpaperDir}/any"
              rm "${wallpaperDir}/any/avatar.png"

              wall-gen --color-set "${./color-set.json}" --output "${wallpaperDir}/${primaryScreen}" -w "${pkgs.wallpapers}/avatar.png"

              wpaperd
            '';
          }
        )
      );
    };

    # Install.WantedBy = [ "graphical-session.target" ];
  };
}
