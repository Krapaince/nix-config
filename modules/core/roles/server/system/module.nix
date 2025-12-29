{
  modules = {
    system = {
      services = {
        sshd.enable = true;
      };
    };
  };

  system.nixos.tags = [ "server" ];
}
