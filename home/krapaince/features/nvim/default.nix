{ pkgs, ... }: {

  home = {
    sessionVariables.EDITOR = "nvim";
    packages = with pkgs; [ nixfmt-classic nil ];
  };
  xdg.configFile."nvim/" = {
    source = ../../../../dotfiles/nvim;
    recursive = true;
  };

  programs.neovim = { enable = true; };
}
