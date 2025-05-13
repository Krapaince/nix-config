{ pkgs, lib, configVars, ... }: {
  # TODO: Make this an option maybe
  imports = [ ./optional/gpg.nix ];

  home.packages = with pkgs; [ delta ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    aliases = {
      lg =
        "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      lg-anonymous =
        "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold yellow)%d%C(reset)' --all";
    };
    userName = configVars.username;
    userEmail = configVars.email;
    signing = {
      key = "EF86373CA45DE4BC";
      signByDefault = true;
    };

    extraConfig = {
      core.editor = "${lib.getExe pkgs.neovim}";

      init.defaultBranch = "master";

      commit.verbose = true;

      delta = {
        enable = true;
        features = "side-by-side line-numbers decorations";
      };

      pager = {
        diff = "delta";
        log = "delta";
        reflog = "delta";
        show = "delta";
      };

      rebase = {
        autostash = true;
        updateRefs = true;
      };

      merge = { autostash = true; };

      pull = {
        autostash = true;
        rebase = true;
      };

      push.default = "current";

      branch.sort = "commiterdate";
    };
  };
}
