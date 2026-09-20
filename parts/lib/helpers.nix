{ lib, ... }:
let
  inherit (lib) mkIf;

  withMainUser =
    config: fun:
    let
      mainUser = config.modules.system.mainUser;
    in
    mkIf (builtins.isString mainUser.name) (fun {
      username = mainUser.name;
      import = mainUser.import;
    });

in
{
  inherit withMainUser;
}
