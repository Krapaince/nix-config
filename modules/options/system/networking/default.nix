{ config, lib, ... }:
let
  inherit (builtins) isString;
  inherit (lib)
    mkEnableOption
    mergeAttrsList
    mkOption
    types
    ;

  networking = config.modules.system.networking;
  connections = config.modules.system.networking.wireless.connections;

  mkConnection = name: {
    "${name}".enable = mkEnableOption "Enable the wireless connection ${name}";
    "${name}'".enable = mkOption {
      type = types.bool;
      readOnly = true;
      default = config.networking.networkmanager.enable && connections."${name}".enable;
    };
  };
in
{
  options.modules.system.networking = {
    interfaces = {
      wired = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Main wired interface.

          Used for waybar
        '';
      };
      wireless = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Main wireless interface.

          Used for wireless connections and waybar
        '';
      };
    };

    wireless = {
      connections =
        [
          "base"
          "secretBase"
        ]
        |> (map mkConnection)
        |> mergeAttrsList;
    };
  };

  config.assertions = [
    {
      assertion =
        config.networking.wireless.enable == false
        || (config.networking.wireless.enable == true && (isString networking.interfaces.wireless));
      message = ''
        ${config.meta.hostname} should set the option networking.interfaces.wireless as wireless is enabled.
      '';
    }
  ];
}
