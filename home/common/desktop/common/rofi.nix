{ pkgs, config, ... }:
{
  programs.rofi = {
    enable = true;

    font = config.fontProfiles.regular.family;

    extraConfig = {
      icon-theme = "Papirus";
      show-icons = true;

      kb-remove-to-eol = "";
      kb-accept-entry = "Return";

      kb-row-up = "Control+k";
      kb-row-down = "Control+j";
    };

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          background-color = mkLiteral "#282C33";
          border-color = mkLiteral "#2e343f";
          text-color = mkLiteral "#8ca0aa";
          spacing = 0;
          width = 256;
        };

        inputbar = {
          border = mkLiteral "0 0 1px 0";
          children = map mkLiteral [
            "prompt"
            "entry"
          ];
        };

        prompt = {
          padding = mkLiteral "16px";
          border = mkLiteral "0 3px 0 0";
        };

        textbox = {
          background-color = mkLiteral "#2e343f";
          border = mkLiteral "0 0 1px 0";
          border-color = "#282C33";
          padding = mkLiteral "8px 16px";
        };

        entry = {
          padding = mkLiteral "16px";
        };

        listview = {
          cycle = false;
          margin = mkLiteral "0 0 -1px 0";
          scrollbar = false;
        };

        element = {
          border = mkLiteral "0 0 1px 0";
          padding = mkLiteral "12px";
        };

        "element selected, element-text selected, element-icon selected" = {
          background-color = mkLiteral "#2e343f";
        };

        element-icon = {
          padding = mkLiteral "0px 10px 0px 10px";
        };
      };
  };
}
