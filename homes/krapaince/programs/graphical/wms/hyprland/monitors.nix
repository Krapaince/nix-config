{ lib, osConfig, ... }:
let
  inherit (lib.custom) resolveMonitors;

  monitors = osConfig.modules.device.monitors;

  toHyprlandMonitor = (
    m:
    let
      flipped = if m.transform.flipped then 1 else 0;
      rotation = m.transform.rotation / 90;
      transform =
        if m.transform.rotation != 0 || m.transform.flipped then
          ", transform, ${toString (flipped + rotation)}"
        else
          "";
    in
    "${m.name},${
      if m.enabled then
        "${toString m.width}x${toString m.height}@${toString m.refreshRate},${toString m.x}x${toString m.y},1${transform}"
      else
        "disable"
    }"
  );
  resolvedMonitors = resolveMonitors monitors;
in
map toHyprlandMonitor resolvedMonitors
