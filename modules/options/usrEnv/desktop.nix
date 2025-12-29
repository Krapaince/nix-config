{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) isString;
  inherit (lib) mkOption types;

  cfg = config.modules.usrEnv;
  sys = config.modules.system;
in
{
  options.modules.usrEnv = {
    wm = mkOption {
      type = types.enum [
        "none"
        "Hyprland"
      ];
      default = "none";
    };

    wms = {
      hyprland = {
        enable = mkOption {
          type = types.bool;
          default = cfg.wm == "Hyprland";
          readOnly = true;
        };

        package = mkOption {
          type = lib.package;
          default = pkgs.hyprland;
        };
      };
    };

    useHomeManager = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.assertions = [
    {
      assertion = cfg.useHomeManager -> isString sys.mainUser.name;
      message = "modules.system.mainUser.name must be set while modules.usrEnv.useHomeManager is enabled";
    }
  ];
}
