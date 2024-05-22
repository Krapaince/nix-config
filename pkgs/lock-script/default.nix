{ writeShellApplication, swaylock }:
writeShellApplication {
  name = "lock-script";
  runtimeInputs = [ swaylock ];
  text = ''
    swaylock
  '';
}
