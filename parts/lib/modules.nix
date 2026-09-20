{ lib, ... }:
let
  inherit (builtins)
    filter
    elem
    ;

  inherit (lib.filesystem) listFilesRecursive;

  inherit (lib.strings) hasSuffix;
  mkModuleTree =
    {
      path,
      suffix,
      ignorePath ? [ ],
    }:
    path
    |> listFilesRecursive
    |> (filter (path: !(elem path ignorePath)))
    |> (map toString)
    |> (filter (hasSuffix suffix));
in
{
  inherit mkModuleTree;
}
