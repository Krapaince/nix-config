{
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 48.8;
    longitude = 2.3;
    temperature = {
      day = 6500;
      night = 4500;
    };
    settings = { general.adjustment-method = "wayland"; };
  };
}
