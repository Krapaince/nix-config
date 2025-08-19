{ config, ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {

      font = config.fontProfiles.regular.family;

      scaling = "fill";
      color = "000000";
      bs-hl-color = "fc7e7e";
      caps-lock-bs-hl-color = "fc7e7e";
      caps-lock-key-hl-color = "fefedf";
      font-size = 13;
      indicator-caps-lock = true;
      indicator-radius = 74;
      indicator-thickness = 5;
      indicator-x-position = 942;
      indicator-y-position = 425;
      inside-caps-lock-color = "00000000";
      inside-clear-color = "fefedf10";
      inside-color = "00000000";
      inside-ver-color = "ffca28a0";
      inside-wrong-color = "00000000";
      key-hl-color = "fefedf";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "fefedfa0";
      line-caps-lock-color = "fff59d";
      line-clear-color = "00000000";
      line-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      ring-caps-lock-color = "00000000";
      ring-clear-color = "00000000";
      ring-color = "00000000";
      ring-ver-color = "00000000";
      ring-wrong-color = "ae5043";
      separator-color = "00000000";
      text-caps-lock-color = "00000000";
      text-clear-color = "00000000";
      text-color = "00000000";
      text-ver-color = "00000000";
      text-wrong-color = "00000000";
    };
  };
}
