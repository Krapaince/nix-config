{ pkgs, ... }: {
  imports = [ ./fish.nix ./git.nix ./gitui.nix ./oh-my-posh.nix ./ssh.nix ];

  home.packages = with pkgs; [
    bat
    bc
    btop
    curl
    dust
    eza
    fd
    inotify-tools
    jq
    man
    man-pages
    ncdu
    ripgrep
    sshfs
    tree
    unzip
    yt-dlp

    nvd
  ];
}
