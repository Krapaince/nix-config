{ inputs, ... }: {
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      netbootCfg = inputs.self.nixosConfigurations.tui.config;
      netboot = netbootCfg.system.build;

      dhcp_port = 67;
      tftp_port = 69;
      proxy_dhcp_port = 4011;

      http_port = 80;
      status_port = http_port;

      ports = "UDP: ${toString dhcp_port}, ${toString tftp_port}, ${toString proxy_dhcp_port} | TCP: ${toString http_port}";

      serveImage = pkgs.writeShellApplication {
        name = "launch-pxe-server";
        text = ''
          close_ports() {
            echo "Removing ports (${ports}) from firewall"
            iptables -w -D nixos-fw -p udp --dport ${toString dhcp_port} -j nixos-fw-accept || true
            iptables -w -D nixos-fw -p udp --dport ${toString tftp_port} -j nixos-fw-accept || true
            iptables -w -D nixos-fw -p udp --dport ${toString proxy_dhcp_port} -j nixos-fw-accept || true

            iptables -w -D nixos-fw -p tcp --dport ${toString http_port} -j nixos-fw-accept || true
            iptables -w -D nixos-fw -p tcp --dport ${toString status_port} -j nixos-fw-accept || true
          }
          trap close_ports EXIT

          echo "Opening ports (${ports})"
          iptables -w -I nixos-fw -p udp --dport ${toString dhcp_port} -j nixos-fw-accept
          iptables -w -I nixos-fw -p udp --dport ${toString tftp_port} -j nixos-fw-accept
          iptables -w -I nixos-fw -p udp --dport ${toString proxy_dhcp_port} -j nixos-fw-accept

          iptables -w -I nixos-fw -p tcp --dport ${toString http_port} -j nixos-fw-accept
          iptables -w -I nixos-fw -p tcp --dport ${toString status_port} -j nixos-fw-accept

          ${lib.getExe pkgs.pixiecore} boot ${netboot.kernel}/bzImage ${netboot.netbootRamdisk}/initrd \
            --cmdline 'init=${netboot.toplevel}/init ${toString netbootCfg.boot.kernelParams}' \
            --debug \
            --dhcp-no-bind \
            --listen-addr 0.0.0.0 \
            --port ${toString http_port} \
            --status-port ${toString status_port}
        '';
      };
    in
    {
      devShells = {
        netboot = pkgs.mkShell {
          packages = [
            serveImage
          ];
        };
      };
    };
}
