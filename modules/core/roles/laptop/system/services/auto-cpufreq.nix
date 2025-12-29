{ lib, ... }:
{
  # nixos-hardware enables this service
  services.tlp.enable = lib.mkForce false;
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
