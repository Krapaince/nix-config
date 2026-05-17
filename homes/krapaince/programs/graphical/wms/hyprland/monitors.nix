{ lib, osConfig, ... }:
let
  toLua = lib.generators.toLua;
  inherit (lib) mkIf;
  inherit (lib.custom) resolveMonitors;

  env = osConfig.modules.usrEnv;

  monitors = osConfig.modules.device.monitors;

  toHyprlandMonitor = (
    m:
    let
      flipped = if m.transform.flipped then 1 else 0;
      rotation = m.transform.rotation / 90;
    in
    {
      output = m.name;
    }
    // (
      if m.enabled then
        {
          mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          position = "${toString m.x}x${toString m.y}";
          scale = 1;
          transform = flipped + rotation;
        }
      else
        { disabled = !m.enabled; }
    )
  );
  resolvedMonitors = resolveMonitors monitors;
  luaMonitors = toLua { } (map toHyprlandMonitor resolvedMonitors);
in
{
  config = mkIf env.wms.hyprland.enable {
    xdg.configFile."hypr/monitors.lua".text = ''
      local monitors = ${luaMonitors};

      for _, monitor in ipairs(monitors) do
        hl.monitor(monitor)
      end
    '';
  };
}
