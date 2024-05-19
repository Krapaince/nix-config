{ ... }: {
  programs.fish = {
    enable = true;

    shellAliases = {
      v = "nvim";
      c = "clear";
      ls = "exa --icons";

      cdc = "cd ~/.config";
      cdg = "cd ~/Desktop/GIT";

      gs = "git status";
      gu = "gitui --watcher";
    };

    functions = { fish_greeting = ""; };
  };
}
