# Bootstrap

Manual operations to set up an host.

## Reinstall an host

1. Serve install medium via PXE

```bash
nix develop .#devShells.x86_64-linux.netboot --command bash -c "sudo launch-pxe-server"
```

2.  Format the disk with the `format-script` script
3.  Report the system disk's uuid inside the host nix filesystem file
4.  Bootstrap the host with the `bootstrap` script
5.  Create a new secret file for the host

    ```bash
    SOPS_AGE_KEY_FILE=key.txt sops edit -a <host-age-recipient> hosts/<host>.yaml
    SOPS_AGE_KEY_FILE=key.txt sops updatekeys hosts/<host>.yaml

    # Sync edited nix-config
    rsync  --progress -avhz nix-config nixos@<ip>:
    ```

6.  Set up Gitlab ssh key to fetch secret repo
7.  Install host

    ```bash
    sudo nixos-install --flake .#<host> --no-root-password
    ```

8.  Reboot
