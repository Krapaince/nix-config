{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) flatten mkIf optionals;

  sys = osConfig.modules.system;
  profiles = osConfig.modules.profiles;
  prg = sys.programs;
in
{
  config = mkIf (prg.gui.enable && sys.video.enable) {
    home.packages =
      with pkgs;
      (flatten [
        gimp
        krita
        pinta
        wdisplays
        xdragon

        # plasma packages
        kdePackages.dolphin
        kdePackages.ark
        kdePackages.kio
        kdePackages.kio-extras
        kdePackages.kimageformats
        kdePackages.kdegraphics-thumbnailers

        (optionals (!profiles.work.enable) (with pkgs; [ mumble ]))

        wf-recorder
        wl-clipboard
        wl-mirror
        wl-screenrec
      ]);
  };
}
