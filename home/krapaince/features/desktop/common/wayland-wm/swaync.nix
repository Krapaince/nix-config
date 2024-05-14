{ ... }: {
  services.swaync = {
    enable = true;
    settings = {
      control-center-height = 600;
      control-center-margin-bottom = 0;
      control-center-margin-left = 0;
      control-center-margin-right = 0;
      control-center-margin-top = 0;
      control-center-width = 500;
      fit-to-screen = true;
      hide-on-action = true;
      hide-on-clear = false;
      image-visibility = "when-available";
      keyboard-shortcuts = true;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      notification-icon-size = 32;
      notification-window-width = 300;
      positionX = "right";
      positionY = "top";
      script-fail-notify = true;
      timeout = 10;
      timeout-critical = 10;
      timeout-low = 10;
      transition-time = 200;
      widget-config = {
        dnd = { text = "Do Not Disturb"; };
        mpris = {
          image-radius = 12;
          image-size = 96;
        };
        title = {
          button-text = "Clear All";
          clear-all-button = true;
          text = "Notifications";
        };
      };
      widgets = [ "title" "dnd" "notifications" "mpris" ];
    };
  };
}
