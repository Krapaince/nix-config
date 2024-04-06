{ pkgs, lib, config, ... }:
{
  programs.fish = {
    enable = true;

    functions = {
      fish_greeting = "";
    };
  };
}
