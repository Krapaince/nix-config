{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "launch-apps";
  runtimeInputs = with pkgs; [ hyprland kitty pavucontrol jq ];
  text = ''
    function wait_for_app_to_open {
      echo "Waiting for $1 to open"
      while true; do
        if hyprctl clients -j | jq -e ".[] | select(.class == \"$1\")" > /dev/null; then
          break;
        fi
        echo "$1 not open yet"
        sleep 0.5s
      done
    }

    hyprctl -q keyword input:follow_mouse 0

    hyprctl -q dispatch workspace 5
    sleep 0.2s
    echo "Opening firefox"
    hyprctl -q dispatch exec firefox
    echo "Waiting for firefox to open and rename its windows"
    sleep 7s

    hyprctl -q dispatch focuswindow "title:^FW7.*"
    hyprctl -q dispatch togglegroup
    echo "Opening Slack"
    hyprctl -q dispatch exec slack
    wait_for_app_to_open "Slack"

    echo "Opening pavucontrol"
    hyprctl -q dispatch exec "pavucontrol --tab 4"
    wait_for_app_to_open "org.pulseaudio.pavucontrol"
    sleep 0.8s

    if hyprctl monitors -j | jq -e '.[] | select(.description == "Lenovo Group Limited E24-28 VVP43933")' > /dev/null; then
      hyprctl -q dispatch moveworkspacetomonitor "7 DP-2"
      hyprctl -q dispatch moveoutofgroup
      hyprctl -q dispatch resizeactive 0 600
    else
      hyprctl -q dispatch moveoutofgroup
      hyprctl -q dispatch movewindow l
      hyprctl -q dispatch resizeactive -500 0
    fi

    hyprctl -q dispatch workspace 2
    echo "Opening kitty"
    hyprctl -q dispatch exec "kitty"

    hyprctl -q keyword input:follow_mouse 1
  '';
}
