{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./gitui.nix
    ./oh-my-posh.nix
    ./ssh.nix
    ./tmux
  ];

  home.packages = with pkgs; [
    bat
    bc
    btop
    curl
    direnv
    dust
    eza
    fd
    ffmpeg
    fzf
    inotify-tools
    jq
    man
    man-pages
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
  ];
}
