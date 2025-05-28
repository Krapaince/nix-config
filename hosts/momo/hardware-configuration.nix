{
  boot = {
    initrd = {
      availableKernelModules = [ "uas" ];
      systemd.tpm2.enable = false;
      systemd.users.root.shell = "/bin/systemd-tty-ask-password-agent";

      network = {
        enable = true;
        ssh = {
          enable = true;
          # Prevent conflict in known hosts
          port = 23;
          authorizedKeyFiles = [ ../../home/krapaince/pabu/ssh.pub ];
          # Usage of initrd's secrets isn't supported for
          # generic-extlinux-compatible boot loader
          # See https://github.com/NixOS/nixpkgs/issues/247145
          #
          # This requires momo to set the nix impure flag though :|
          hostKeys = [ /persist/system/etc/ssh/ssh_host_ed25519_key_initrd ];
        };
      };
    };

    kernelParams = [
      "ip=192.168.1.57::192.168.1.1:255.255.255.0:momo::none"
      "console=tyAMA0,115200"
      "console=tty1"
    ];
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  powerManagement.cpuFreqGovernor = "ondemand";
}
