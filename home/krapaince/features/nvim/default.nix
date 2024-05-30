{ pkgs, ... }: {

  home = {
    sessionVariables.EDITOR = "nvim";
    packages = with pkgs; [
      nodejs_20
      gnumake
      tree-sitter

      # Github action
      actionlint

      nodePackages.bash-language-server
      nodePackages.typescript-language-server

      dockerfile-language-server-nodejs

      lua-language-server
      stylua

      prettierd

      texlab

      # Python
      black
      pyright

      # HTML/CSS/JSON
      vscode-langservers-extracted

      # Nix
      nixfmt-classic
      nil

      yaml-language-server
    ];
  };
  xdg.configFile."nvim/" = {
    source = ../../../../dotfiles/nvim;
    recursive = true;
  };

  programs.neovim = { enable = true; };
}
