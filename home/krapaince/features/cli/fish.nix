{ config, lib, ... }: {
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

      bs = "sudo systemctl start bluetooth";

    } // lib.optionalAttrs
      ((config ? sops) && (config.sops.secrets ? "bluetooth/headset_addr")) {
        bc = "bluetoothctl connect (cat ${
            config.sops.secrets."bluetooth/headset_addr".path
          })";
      };

    functions = { fish_greeting = ""; };
  };
}
