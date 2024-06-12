{ writeShellApplication, playerctl, systemd }:
writeShellApplication {
  name = "suspend-script";
  runtimeInputs = [ playerctl systemd ];
  text = builtins.readFile ./suspend.sh;
}
