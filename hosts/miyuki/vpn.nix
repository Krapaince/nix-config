{ inputs, config, ... }: {
  services.strongswan = {
    enable = true;

    ca = {
      kbrwvpn = {
        auto = "add";
        cacert = "${inputs.secrets}/hosts/miyuki/ca-cert.pem";
      };
    };

    connections = let
      makeVpnConf = name: fqdn: identity: {
        name = name;
        value = {
          right = fqdn;
          rightid = fqdn;
          rightsubnet = "0.0.0.0/0,::/0";
          rightauth = "pubkey";
          leftsourceip = "%config4,%config6";
          leftauth = "eap-mschapv2";
          eap_identity = identity;
          auto = "start";
        };
      };
    in builtins.listToAttrs (builtins.map (e:
      makeVpnConf (builtins.elemAt e 0) (builtins.elemAt e 1)
      (builtins.elemAt e 2)) inputs.secrets.work.vpn);

    secrets = [ "${config.hostSpec.persistFolder}/system/etc/ipsec.d/secrets" ];
  };
}
