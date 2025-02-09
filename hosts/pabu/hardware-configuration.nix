{
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
    };
    supportedFilesystems = [ "btrfs" ];
    kernelModules = [ "kvm-intel" ];

    loader = {
      systemd-boot = {
        configurationLimit = 20;
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
