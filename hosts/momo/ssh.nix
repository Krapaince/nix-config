{ configVars, ... }:
let username = configVars.username;
in {
  users.users.${username} = {
    openssh.authorizedKeys.keyFiles = let hostnames = [ "pabu" ];
    in map
    (hostname: builtins.toPath "../../home/${username}/${hostname}/ssh.pub")
    hostnames;
  };
}
