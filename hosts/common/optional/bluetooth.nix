{ pkgs, ... }: {
  hardware.bluetooth = {
    enable = true;
    settings = { General = { Experimental = true; }; };
    powerOnBoot = true;
  };

  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  services.blueman.enable = true;
}
