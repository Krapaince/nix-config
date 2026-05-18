{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (import ./packages { inherit pkgs; }) toggle-animation;

  env = osConfig.modules.usrEnv;
in
{
  imports = [
    ./monitors.nix
    ./nix.nix
  ];

  config = mkIf env.wms.hyprland.enable {
    home.packages = [ toggle-animation ];
    services.hyprpolkitagent.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      systemd.enable = true;
      extraConfig = ''
        ${builtins.readFile ./hyprland.lua}
      '';

    };

    xdg.configFile = {
      "hypr/bindings.lua".source = ./bindings.lua;
      "hypr/events.lua".source = ./events.lua;
      "hypr/rules.lua".source = ./rules.lua;
    };
  };
}
