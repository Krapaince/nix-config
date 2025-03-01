{
  boot = {
    initrd = {
      availableKernelModules = [
        "uas"
        "usbhid"
        "usb_storage"
        "vc4"
        "pcie_brcmstb"
        "reset-raspberrypi"
      ];
      systemd.tmp2.enable = false;
    };
    # kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

    loader = {
      systemd-boot = {
        configurationLimit = 20;
        enable = true;
      };
    };
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  powerManagement.cpuFreqGovernor = "ondemand";
}
