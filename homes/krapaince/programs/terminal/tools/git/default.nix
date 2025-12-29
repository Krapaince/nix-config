{
  osConfig,
  lib,
  pkgs,
  self',
  ...
}:
let
  inherit (builtins) isString;
  inherit (lib) mkIf;

  gitPkg = pkgs.gitFull;

  watchGitlog = pkgs.writeShellApplication {
    name = "watch-gitlog";
    runtimeInputs = with pkgs; [
      coreutils
      inotify-tools
      gitPkg
      ncurses6

      self'.packages.gsettings2
    ];
    text = builtins.readFile ./watch-gitlog;
    bashOptions = [
      "errexit"
      "nounset"
    ];
    inheritPath = false;
  };

  prg = osConfig.modules.system.programs;
  signKeyOrNull = prg.git.signKey;
in
{
  home.packages = with pkgs; [
    delta
    watchGitlog
  ];

  programs.git = {
    enable = true;
    package = gitPkg;

    signing = mkIf (isString signKeyOrNull) {
      key = signKeyOrNull;
      signByDefault = true;
    };

    settings = {
      user = {
        email = prg.git.email;
        name = prg.git.name;
      };

      alias = {
        lg = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        lgl = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(black)%s%C(reset) %C(dim black)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        lg-anonymous = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold yellow)%d%C(reset)' --all";
      };

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
