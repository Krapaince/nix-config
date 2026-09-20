{ lib, osConfig, ... }:
{
  config = lib.custom.withDeviceType osConfig [ "laptop" ] {
    services.network-manager-applet.enable = true;
  };
}
