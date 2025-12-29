{ config, ... }:
{
  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    settings = {
      palette = {
        red = "#c70403";
        green = "#1fea00";
        yellow = "#acaa01";
        blue = "#0d73cc";
        white = "#FFFFFF";
        black = "#111111";

        git-changes = "#cecb00";
        git-clean = "#19cb00";
      };

      blocks = [
        {
          alignment = "left";
          newline = true;
          segments = [
            {
              type = "status";
              style = "plain";
              foreground = "p:red";
              template = "{{ if .Error}}({{ .Code }}){{ end }}";
            }
            {
              background = "p:black";
              foreground = "p:white";
              template = " <p:green>{{if .Root }}<p:red>{{ end }}{{ .UserName }}{{if .Root }}</>{{ end }}</>@{{if .SSHSession}}<p:yellow>{{ end }}{{ .HostName }}{{if .SSHSession}}</>{{ end }}";
              style = "diamond";
              trailing_diamond = "";
              type = "session";
            }
            {
              background = "p:blue";
              foreground = "p:black";
              powerline_symbol = "";
              template = " {{ .Path }} ";
              style = "powerline";
              properties = {
                style = "unique";
              };
              type = "path";
            }
            {
              background = "p:git-clean";
              background_templates = [ "{{ if or .Working.Changed .Staging.Changed }}p:git-changes{{ end }}" ];
              foreground = "p:black";
              powerline_symbol = "";
              template = " {{ .HEAD }} ";
              style = "powerline";
              type = "git";
            }
          ];
          type = "prompt";
        }
      ];
      final_space = true;
      version = 2;
    };
  };
}
