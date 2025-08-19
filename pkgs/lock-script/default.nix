{
  writeShellApplication,
  swaylock,
  wpaperd,
  gnugrep,
  gnused,
  coreutils,
  gawk,
}:
writeShellApplication {
  name = "lock-script";
  runtimeInputs = [
    coreutils
    gawk
    gnugrep
    gnused
    swaylock
    wpaperd
  ];
  text = builtins.readFile ./lock.sh;
}
