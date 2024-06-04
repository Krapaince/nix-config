{
  users.users.krapaince = {
    openssh.authorizedKeys.keyFiles = let hostnames = [ "pabu" ];
    in map
    (hostname: builtins.toPath "../../home/krapaince/${hostname}/ssh.pub")
    hostnames;
  };
}
