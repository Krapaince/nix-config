{
  inputs',
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) getExe' mkIf;

  env = osConfig.modules.usrEnv;
in
{
  config = mkIf env.wms.hyprland.enable {
    systemd.user.services.hyprland-ipc = {
      Unit = {
        Description = "IPC script that handles Hyprland events.";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service =
        let
          hyprland_ipc = getExe' inputs'.hyprland-ipc.packages.hyprland-ipc "hyprland_ipc";
        in
        {
          ExecStart = "${hyprland_ipc} start";
          Restart = "on-failure";
        };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
