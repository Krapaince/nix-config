{ lib, pkgs, ... }: {

  home = {
    sessionVariables.EDITOR = "nvim";
    packages = with pkgs; [
      nodejs_20
      yarn
      gnumake
      gcc
      tree-sitter

      # Github action
      actionlint

      clang-tools

      nodePackages.bash-language-server
      nodePackages.typescript-language-server

      dockerfile-language-server-nodejs

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
      elixir_ls
      erlang-ls

      # Nix
      nixfmt-classic
      nixd

      yaml-language-server
    ];
  };
  xdg.configFile."nvim/" = {
    source = lib.custom.relativeToRoot "dotfiles/nvim";
    recursive = true;
  };

  programs.neovim = { enable = true; };
}
