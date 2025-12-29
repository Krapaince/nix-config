{ pkgs, ... }:
{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    defaultCacheTtl = 3600;
    maxCacheTtl = 3600;
    pinentry.package = pkgs.pinentry-curses;
  };
}
