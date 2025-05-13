# Bootstrap

Manual operations to set up an host.

## Reinstall an host

- Make an ISO and boot with it
  ```bash
  rm -rf result
  nix build .#nixosConfigurations.iso.config.system.build.isoImage
  ```

- Clone this repository on the host
- Format the disk
  ```bash
  disko --mode destroy ./hosts/<host>/disko.nix
  diskp --mode format ./hosts/<host>/disko.nix
  diskp --mode mount ./hosts/<host>/disko.nix
  ```

- Set up persistent directories/file
  ```bash
  ./scripts/setup-opt-in-state.sh
  ```

- Copy the host's private key
    - For new machine
        - Generate the host's key `ssh-keygen -t ed25519 -f ssh_host_ed25519_key`
        - Convert host key to age key for secret `cat ssh_host_ed25519_key.pub | ssh-to-age`
        - Generate a new key for the user-host couple via age `age-keygen`

- Set up an access to gitlab via ssh (to fetch secrets repo)
- Install host
  ```bash
  sudo nixos-install --flake .#<host>
  ```
  ask root password but can be ignored
  

- After install, ask for root password but doesn't requires it after reboot
- Reboot
