{ lib }:
let
  resolveMonitors = (monitors:
    let
      unresolvedMonitors = lib.filter (m:
        (lib.isString m.name) && (builtins.isNull m.x) && (builtins.isNull m.y))
        monitors;
      resolvedMonitors = lib.filter
        (m: (lib.isString m.name) && (lib.isInt m.x) && (lib.isInt m.y))
        monitors;
      result = resolveMonitorsPosition {
        resolvedMonitors = resolvedMonitors;
        unresolvedMonitors = [ ];
        didResolve = false;
      } unresolvedMonitors;
    in if result.didResolve == false then
      abort ''
        Couldn't not resolved position of the following monitors:
        ${lib.concatMapStringsSep "\n"
        (m: " ${m.name} which is ${m.relativeTo} at ${m.west}")
        result.unresolvedMonitors}''
    else if result.unresolvedMonitors != [ ] then
      resolveMonitors (result.resolvedMonitors ++ result.unresolvedMonitors)
    else
      result.resolvedMonitors);

  resolveMonitorsPosition = lib.lists.foldl
    ({ resolvedMonitors, unresolvedMonitors, didResolve, ... }:
      unresolvedMonitor:
      let
        resolvedRelativeMonitor =
          (findResolvedRelativeMonitor unresolvedMonitor resolvedMonitors);

        canResolve = lib.isAttrs resolvedRelativeMonitor;

        monitor = lib.optionals canResolve [
          (lib.attrsets.removeAttrs (computeRelativePosition unresolvedMonitor
            resolvedRelativeMonitor) [ "direction" "relativeTo" ])
        ];

        unresolvedMonitor2 = lib.optionals (!canResolve) [ unresolvedMonitor ];

      in {
        resolvedMonitors = monitor ++ resolvedMonitors;
        unresolvedMonitors = unresolvedMonitor2 ++ unresolvedMonitors;
        didResolve = didResolve || canResolve;
      });

  findResolvedRelativeMonitor = (unresolvedMonitor: monitors:
    lib.lists.findFirst
    (m: (m.name == unresolvedMonitor.relativeTo) && (m ? x) && (m ? y)) null
    monitors);

  computeRelativePosition = (unresolvedMonitor: relativeMonitor:
    let
      directionToMultiplier = (direction: {
        v = if lib.strings.hasInfix "north" direction then
          -1
        else if lib.strings.hasInfix "south" direction then
          1
        else
          0;
        h = if lib.strings.hasInfix "west" direction then
          -1
        else if lib.strings.hasInfix "east" direction then
          1
        else
          0;
      });

      multiplier = directionToMultiplier unresolvedMonitor.direction;
      rotation = lib.attrByPath [ "transform" "rotation" ] 0 unresolvedMonitor;
      shouldInvert = rotation == 90 || rotation == 270;
      width = if shouldInvert then
        unresolvedMonitor.height
      else
        unresolvedMonitor.width;
      height = if shouldInvert then
        unresolvedMonitor.width
      else
        unresolvedMonitor.height;
      x = relativeMonitor.x + (multiplier.h * width) + unresolvedMonitor.offsetX;
      y = relativeMonitor.y + (multiplier.v * height) + unresolvedMonitor.offsetY;

    in unresolvedMonitor // { inherit x y; });

in resolveMonitors
