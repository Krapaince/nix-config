{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showHelp = false;
        showStartupLaunchMessage = false;
        disabledGrimWarning = true;
      };
    };
  };

  xdg.configFile."systemd/user/flameshot.service.d/99-env.conf".text = ''
    [Service]
    Environment="XDG_CURRENT_DESKTOP=sway"
    Environment="XDG_SESSION_DESKTOP=sway"
    Environment="QT_QPA_PLATFORM=wayland"
  '';

}
