{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.custom) mkThemeSwitchHook;

  sys = osConfig.modules.system;
in
{
  config = mkIf (sys.programs.editors.neovim.enable) {
    home = {
      packages = with pkgs; [
        silicon

        nodejs_24
        yarn
        gnumake
        gcc
        tree-sitter

        # Github action
        actionlint

        clang-tools

        nodePackages.bash-language-server
        nodePackages.typescript-language-server

        dockerfile-language-server

        lua-language-server
        stylua

        eslint_d
        prettierd

        texlab

        # Python
        black
        pyright

        # HTML/CSS/JSON
        vscode-langservers-extracted

        # XML
        lemminx

        elixir
        elixir-ls
        erlang
        erlang-language-platform

        # Nix
        nixfmt
        nixd

        rust-analyzer

        yaml-language-server
      ];
    };
    xdg.configFile."nvim/" = {
      source = ../../../../../../dotfiles/nvim;
      recursive = true;
    };

    programs.neovim = {
      enable = true;
    };

    theme.switch.hooks = [
      (mkThemeSwitchHook {
        inherit pkgs;
        program = "nvim";
        runtimeInputs = [ pkgs.procps ];
        text = "pkill -USR1 nvim || true";
      })
    ];
  };
}
