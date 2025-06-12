{
  services.blueman-applet.enable = true;

  services.mpris-proxy.enable = true;

  xdg.configFile."wireplumber/wireplumber.conf.d/10.bluetooth-policy.conf".text =
    ''
      wireplumber.settings = {
          bluetooth.autoswitch-to-headset-profile = false
      }
    '';
}
