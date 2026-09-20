{ lib, ... }:
let
  inherit (builtins) elem;
  inherit (lib) mkIf;

  isAcceptedDeviceType = config: types: elem config.modules.device.type types;

  withDeviceType =
    config: types: term:
    mkIf (isAcceptedDeviceType config types) term;

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
  inherit isAcceptedDeviceType withDeviceType withMainUser;
}
