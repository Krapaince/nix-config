{
  boot = {
    initrd = {
      availableKernelModules = [ "uas" ];
      systemd.tpm2.enable = false;
    };

    kernelParams = [ "console=tyAMA0,115200" "console=tty1" ];
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  powerManagement.cpuFreqGovernor = "ondemand";
}
