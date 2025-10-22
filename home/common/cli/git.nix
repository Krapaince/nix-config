{
  pkgs,
  lib,
  config,
  ...
}:
{
  # TODO: Make this an option maybe
  imports = [ ./optional/gpg.nix ];

  home.packages = with pkgs; [ delta ];

  programs.git =
    let
      identity = config.hostSpec.identity;
    in
    {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      signing = {
        key = identity.gpg_key;
        signByDefault = true;
      };

      settings = {
        user = {
          email = identity.email;
          name = identity.userFullName;
        };

        alias = {
          lg = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
          lgl = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(black)%s%C(reset) %C(dim black)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
          lg-anonymous = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold yellow)%d%C(reset)' --all";
        };

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

        merge = {
          autostash = true;
        };

        pull = {
          autostash = true;
          rebase = true;
        };

        push.default = "current";

        branch.sort = "committerdate";
      };
    };
}
