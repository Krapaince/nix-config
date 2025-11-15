{ config, ... }:
{
  home.sessionVariables.IEX_HOME = (toString config.xdg.configHome) + "/elixir";
  xdg.configFile."elixir/.iex.exs".source = ./iex.exs;
}
