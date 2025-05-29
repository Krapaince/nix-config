{ lib }: {
  mkScript = { name, deps ? [ ], script, pkgs }:
    lib.getExe (pkgs.writeShellApplication {
      inherit name;
      text = script;
      runtimeInputs = deps;
    });

  scanPaths =
    path:
      path
      |> builtins.readDir
      |> (lib.attrsets.filterAttrs (path: type:
        (type == "directory") || ((path != "default.nix") && (lib.strings.hasSuffix ".nix" path))
      ))
      |> builtins.attrNames
      |> builtins.map (filepath: path + "/${filepath}");

  relativeToRoot = lib.path.append ../.;
}
