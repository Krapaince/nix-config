{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "toggle-animation";
  runtimeInputs = with pkgs; [
    gawk
    hyprland
  ];
  text = ''
    ANIMATION_STATE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

    if [[ "$ANIMATION_STATE" -eq 1 ]]; then
      hyprctl --batch "\
        keyword animations:enabled 0;"
    else
      hyprctl --batch "\
        keyword animations:enabled 1;"
    fi
  '';
}
