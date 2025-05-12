{ lib }: {
  mkScript = { name, deps ? [ ], script, pkgs }:
    lib.getExe (pkgs.writeShellApplication {
      inherit name;
      text = script;
      runtimeInputs = deps;
    });

  relativeToRoot = lib.path.append ../.;
}
