{
  config,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mergeAttrsList mkIf optionalAttrs;

  secrets = config.sops.secrets;
  prg = config.programs;
  sys = osConfig.modules.system;
in
{
  programs.fish = {
    enable = true;

    shellAliases = mergeAttrsList [
      {
        v = "nvim";
        c = "clear";
        ls = "exa --icons";

        cdc = "cd ~/.config";
        cdg = "cd ~/Desktop/GIT";

        gs = "git status";
        gu = "gitui --watcher";

        bs = "sudo systemctl start bluetooth";
        bd = "bluetoothctl disconnect";

      }
      (optionalAttrs sys.bluetooth.enable {
        bc = "bluetoothctl connect (cat ${secrets."bluetooth/headset_addr".path})";
      })
    ];

    functions = {
      fish_greeting = "";
      ya = mkIf prg.yazi.enable ''
        set tmp (mktemp -t "yazi-cwd.XXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        	cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };
  };
}
