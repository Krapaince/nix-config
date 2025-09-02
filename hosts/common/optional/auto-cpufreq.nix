{ lib, ... }:
{
  services.tlp.enable = false;
  services.auto-cpufreq = {
    enable = lib.mkDefault true;
    settings = {
      charger = {
        governor = "balanced";
        turbo = "auto";
      };

      battery = {
        governor = "powersave";
        turbo = "never";
      };
    };
  };
}
