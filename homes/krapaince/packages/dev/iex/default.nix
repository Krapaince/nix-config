{
  config,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  sys = osConfig.modules.system;
in
{
  config = mkIf sys.programs.dev.enable {
    home.sessionVariables.IEX_HOME = (toString config.xdg.configHome) + "/elixir";
    xdg.configFile."elixir/.iex.exs".source = ./iex.exs;
  };
}
