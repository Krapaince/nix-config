{ lib }:
let
  inherit (builtins) isInt;
  inherit (lib)
    concatMapStringsSep
    filter
    findFirst
    foldl
    hasInfix
    isAttrs
    optionals
    ;

  resolveMonitors = (
    monitors:
    let
      unresolvedMonitors = filter (m: (isNull m.x) && (isNull m.y)) monitors;
      resolvedMonitors = filter (m: (isInt m.x) && (isInt m.y)) monitors;
      result = resolveMonitorsPosition {
        resolvedMonitors = resolvedMonitors;
        unresolvedMonitors = [ ];
        didResolve = false;
      } unresolvedMonitors;
    in
    if result.didResolve == false then
      abort ''
        Couldn't not resolved position of the following monitors:
        ${concatMapStringsSep "\n" (
          m: " ${m.name} which is ${m.relativeTo} at ${m.direction}"
        ) result.unresolvedMonitors}''
    else if result.unresolvedMonitors != [ ] then
      resolveMonitors (result.resolvedMonitors ++ result.unresolvedMonitors)
    else
      result.resolvedMonitors
  );

  resolveMonitorsPosition = foldl (
    {
      resolvedMonitors,
      unresolvedMonitors,
      didResolve,
      ...
    }:
    unresolvedMonitor:
    let
      resolvedRelativeMonitor = (findResolvedRelativeMonitor unresolvedMonitor resolvedMonitors);

      canResolve = isAttrs resolvedRelativeMonitor;

      monitor = optionals canResolve [
        (removeAttrs (computeRelativePosition unresolvedMonitor resolvedRelativeMonitor) [
          "direction"
          "relativeTo"
        ])
      ];

      unresolvedMonitor2 = optionals (!canResolve) [ unresolvedMonitor ];

    in
    {
      resolvedMonitors = monitor ++ resolvedMonitors;
      unresolvedMonitors = unresolvedMonitor2 ++ unresolvedMonitors;
      didResolve = didResolve || canResolve;
    }
  );

  findResolvedRelativeMonitor = (
    unresolvedMonitor: monitors:
    findFirst (m: (m.name == unresolvedMonitor.relativeTo) && (m ? x) && (m ? y)) null monitors
  );

  computeRelativePosition = (
    unresolvedMonitor: relativeMonitor:
    let
      # A coordinate corresponds to the top-left corner of a monitor
      direction = unresolvedMonitor.direction;
      offset = {
        y =
          if hasInfix "north" direction then
            -unresolvedMonitor.height
          else if hasInfix "south" direction then
            relativeMonitor.height
          else
            0;
        x =
          if hasInfix "west" direction then
            -unresolvedMonitor.width
          else if hasInfix "east" direction then
            relativeMonitor.width
          else
            0;
      };

      rotation = unresolvedMonitor.transform.rotation;
      shouldInvert = rotation == 90 || rotation == 270;
      xOffset = if shouldInvert then offset.y else offset.x;
      yOffset = if shouldInvert then offset.x else offset.y;
      x = relativeMonitor.x + xOffset + unresolvedMonitor.offsetX;
      y = relativeMonitor.y + yOffset + unresolvedMonitor.offsetY;
    in
    unresolvedMonitor // { inherit x y; }
  );
in
resolveMonitors
