{ config, lib, pkgs, inputs, ... }:
let
  primaryScreen = (lib.findFirst (m: m.primary) null config.monitors).name;
  homeDir = config.home.homeDirectory;
  wallpaperDir = homeDir + "/Pictures/wallpapers";
in {
  programs.wpaperd = {
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
    Unit = {
      Description = "wpaper";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = lib.getExe (pkgs.writeShellApplication {
        name = "wallpaper";
        runtimeInputs = with pkgs; [ wall-gen wpaperd coreutils ];
        text = ''
          mkdir -p "${wallpaperDir}/${primaryScreen}" "${wallpaperDir}/any"

          install -m 644 "${inputs.wallpapers}/"* "${wallpaperDir}/any"
          rm "${wallpaperDir}/any/avatar.png"

          wall-gen --color-set "${
            ./color-set.json
          }" --output "${wallpaperDir}/${primaryScreen}" -w "${inputs.wallpapers}/avatar.png"

          wpaperd
        '';
      });
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
