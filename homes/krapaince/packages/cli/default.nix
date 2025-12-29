{
  lib,
  osConfig,
  pkgs,
  self',
  ...
}:
let
  inherit (lib) mkIf;
  prg = osConfig.modules.system.programs;
in
{
  config = mkIf prg.cli.enable {
    home.packages = with pkgs; [
      bat
      btop
      direnv
      dust
      eza
      fd
      ffmpeg
      fzf
      inotify-tools
      jq
      moreutils
      (lib.hiPrio parallel)
      ncdu
      ripgrep
      sshfs
      tree
      unzip
      yt-dlp

      nh
      nvd

      self'.packages.yt-cutter
    ];
  };
}
