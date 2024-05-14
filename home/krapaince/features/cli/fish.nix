{ ... }: {
  programs.fish = {
    enable = true;

    shellAliases = {
      v = "nvim";
      c = "clear";
      ls = "exa --icons";

      cdc = "cd ~/.config";
      cdg = "cd ~/Desktop/GIT";
    };

    functions = { fish_greeting = ""; };
  };
}
