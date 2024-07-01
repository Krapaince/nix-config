{ writeShellApplication, swaylock, wpaperd, gnused, coreutils, gawk }:
writeShellApplication {
  name = "lock-script";
  runtimeInputs = [ coreutils gawk gnused swaylock wpaperd ];
  text = builtins.readFile ./lock.sh;
}
