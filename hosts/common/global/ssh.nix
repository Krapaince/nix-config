{config, lib, ...}: {
  programs.ssh = let
      hostPath = lib.custom.relativeToRoot "hosts";
      hosts =
        hostPath
        |> builtins.readDir
        |> lib.attrNames
        |> lib.filter(host: (builtins.readDir (hostPath + "/${host}")) ? "ssh_host_ed25519_key.pub");
        |> lib.filter (host_key: (builtins.readFileType host_key) == "regular");
    in {
      knownHosts = lib.genAttrs pubHostsKey (pubHostKey: {
        publicKeyFile = pubHostKey ;
      knownHosts = lib.genAttrs hosts (host: {
        publicKeyFile = hostPath + "/${host}/ssh_host_ed25519_key.pub";
        extraHostNames = (lib.optional (host == config.networking.hostName) "localhost");
      });
    };
}
