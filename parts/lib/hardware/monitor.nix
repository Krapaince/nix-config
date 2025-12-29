{ lib }:
let
  inherit (builtins) isNull isInt;
  inherit (lib)
    concatMapStringsSep
    filter
    findFirst
    foldl
    hasInfix
    isAttrs
    optionals
    removeAttrs
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
      directionToMultiplier = (
        direction: {
          v =
            if hasInfix "north" direction then
              -1
            else if hasInfix "south" direction then
              1
            else
              0;
          h =
            if hasInfix "west" direction then
              -1
            else if hasInfix "east" direction then
              1
            else
              0;
        }
      );

      multiplier = directionToMultiplier unresolvedMonitor.direction;
      rotation = unresolvedMonitor.transform.rotation;
      shouldInvert = rotation == 90 || rotation == 270;
      width = if shouldInvert then unresolvedMonitor.height else unresolvedMonitor.width;
      height = if shouldInvert then unresolvedMonitor.width else unresolvedMonitor.height;
      x = relativeMonitor.x + (multiplier.h * width) + unresolvedMonitor.offsetX;
      y = relativeMonitor.y + (multiplier.v * height) + unresolvedMonitor.offsetY;
    in
    unresolvedMonitor // { inherit x y; }
  );
in
resolveMonitors
