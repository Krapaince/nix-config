# Nixos config

## Installation

```bash
HOST="pabu" # Or any available hostname in flake.nix
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko "./hosts/$HOST/disko.nix"
sudo nixos-install --flake ".#$HOST"
./scripts/setup-opt-in-state.sh
```
