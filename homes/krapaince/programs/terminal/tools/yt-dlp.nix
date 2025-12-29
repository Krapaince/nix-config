{ lib, pkgs, ... }:
let
  inherit (lib) concatMapAttrsStringSep;

  settings = {
    format = ''"bestvideo[height<=1080]+bestaudio/best[height<=1080]"'';
    throttled-rate = "70K";
    output = ''"%(title)s"'';
  };
in
{
  home.packages = [ pkgs.yt-dlp ];

  xdg.configFile."yt-dlp/config".text = concatMapAttrsStringSep "\n" (
    name: value: "--${name} ${value}"
  ) settings;
}
