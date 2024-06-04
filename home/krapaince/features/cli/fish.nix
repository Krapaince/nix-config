{ ... }: {
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -x GPG_TTY (tty)
    '';

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
