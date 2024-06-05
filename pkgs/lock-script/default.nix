{ writeShellApplication, swaylock }:
writeShellApplication {
  name = "lock-script";
  runtimeInputs = [ swaylock ];
  text = builtins.readFile ./lock.sh;
}
