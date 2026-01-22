# Nixos config

Yet another over-engineered nixos flake to power my machines.

## Installation

See [bootstrap.md](./docs/bootstrap.md)

### Repo Structure

- [`docs`](docs) documentation to bootstrap an host
- [`dotfiles`](dotfiles) Dotfiles which aren't nixify because I want to easily
  mess with them when I need to
- [`homes`](homes) Personal Home-Manager configuration
- [`hosts`](hosts) Per-host configurations which are specific to each machine
- [`modules`](modules) Modularized NixOS configurations
  - [`core`](modules/core) The core module that all systems depend on
    - [`common`](modules/core/common) Module configurations shared between all
      hosts
    - [`profiles`](modules/core/profiles) Pluggable internal module system, for
      providing overrides based on host declarations
    - [`roles`](modules/core/roles) A profile-like system that work through
      imports and ship predefined configurations
  - [`extra`](modules/extra) Extra modules that are rarely imported
    - [`shared`](modules/extra/shared) Modules that are imported by the flake
      itself
  - [`options`](modules/options) Definitions of module options used by common
    modules
    - [`device`](modules/options/device) Hardware capabilities of the host
    - [`meta`](modules/options/meta) Internal, read-only module that defines
      host capabilities based on other options
    - [`style`](modules/options/style) Style configuration for QT and GTK
    - [`system`](modules/options/system) OS-wide configurations for generic
      software and firmware on system level
    - [`usrEnv`](modules/options/usrEnv) userspace exclusive configurations.
- [`parts/`](parts)
  - [`lib`](part/lib) Personal library functions an utilities put under the
    `.custom` key of `lib`
  - [`modules`](/part/modules) NixOS/Home-Manager modules provided by this flake
  - [`pkgs`](/parts/pkgs) Personal packages used by this flake
  - [`keys.nix`](/parts/keys.nix) My public keys used across the flake
- [`scripts`](scripts) Miscellaneous scripts to tinker, bootstrap and mess with
  my nix configuration

## Credits

[EmergentMind](https://github.com/EmergentMind) which
made helpful [videos on nix](https://www.youtube.com/@Emergent_Mind/videos)

[NotAShelf](https://github.com/NotAShelf)'s [archive
config](https://github.com/NotAShelf/nyx.git) which was really helpful to
refactor my own configuration from being a mess of optional imports to a maze of
options. But hey, I can now go further down into the rabbit hole.

## Nix resources

### Interactive pages

- [Noogle](https://noogle.dev)
- [NixOS package search](https://search.nixos.org/packages)
- [NixOS option search](https://search.nixos.org/options?)
- [Home-Manager option search](https://home-manager-options.extranix.com/)

### Guides

- [Nix Pills](https://nixos.org/guides/nix-pills/)
