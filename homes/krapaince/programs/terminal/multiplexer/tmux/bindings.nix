{ lib, pkgs, ... }:
let
  inherit (builtins) isString;
  inherit (lib)
    filter
    concatStringsSep
    concatMapStringsSep
    replaceStrings
    toLower
    ;

  # Terminal key bindings sending the tmux prefix (C-b) followed by `chars`.
  # Written in Alacritty's notation, `\e` stands for the escape character.
  terminal =
    let
      mkBind = mods: key: chars: { inherit mods key chars; };
    in
    [
      # Move window
      (mkBind "Super|Shift" "<" "<")
      (mkBind "Super|Shift" ">" ">")

      # Resize pane
      (mkBind "Control|Shift" "h" "\\e[1;5D")
      (mkBind "Control|Shift" "j" "\\e[1;5B")
      (mkBind "Control|Shift" "k" "\\e[1;5A")
      (mkBind "Control|Shift" "l" "\\e[1;5C")

      # Force close pane
      (mkBind "Super" "w" "x")

      # Move between panes
      # https://github.com/alacritty/alacritty/issues/474#issuecomment-2137353585
      (mkBind "Super" "h" "\\e[D")
      (mkBind "Super" "j" "\\e[B")
      (mkBind "Super" "k" "\\e[A")
      (mkBind "Super" "l" "\\e[C")

      # Split pane H/V
      (mkBind "Control|Alt" "Return" "%")
      (mkBind "Control" "Return" "\"")

      # New/Previous/Next Window
      (mkBind "Super|Shift" "t" "c")
      (mkBind "Super|Shift" "h" "p")
      (mkBind "Super|Shift" "l" "n")
      (mkBind "Super|Shift" "q" "&")
    ];
in
{
  alacritty = map (b: {
    inherit (b) key mods;
    # " and & are escaped, a raw " breaks the mapping
    chars = "\\u0002" + replaceStrings [ "\\e" "\"" "&" ] [ "\\u001b" "\\u0022" "\\u0026" ] b.chars;
  }) terminal;

  kitty =
    let
      keyNames = {
        "<" = ",";
        ">" = ".";
        "Return" = "enter";
      };
      mods = m: replaceStrings [ "|" "control" ] [ "+" "ctrl" ] (toLower m);
    in
    lib.listToAttrs (
      map (b: {
        name = "${mods b.mods}+${keyNames.${b.key} or b.key}";
        value = "send_text all \\x02${replaceStrings [ "\\e" ] [ "\\x1b" ] b.chars}";
      }) terminal
    );

  tmux =
    let
      mkBind =
        { key, rest, ... }@attr:
        let
          comment = if attr ? comment then "# ${attr.comment}\n" else "";
          option = if attr ? option then "-${attr.option}" else null;
          table = if attr ? table then "-T ${attr.table}" else null;
          bind =
            [
              "bind"
              option
              table
              key
              rest
            ]
            |> (filter isString)
            |> (concatStringsSep " ");
          unbind =
            [
              "unbind"
              table
              key
            ]
            |> (filter isString)
            |> (concatStringsSep " ");
        in
        ''
          ${comment}${unbind}
          ${bind}
        '';
    in
    concatMapStringsSep "\n" mkBind [
      {
        key = "r";
        rest = "source-file ~/.config/tmux/tmux.conf \\; display-message \"tmux conf reloaded\"";
      }
      {
        key = "'\"'";
        rest = "split-window -v -c \"#{pane_current_path}\"";
      }
      {
        key = "%";
        rest = "split-window -h -c \"#{pane_current_path}\"";
      }
      {
        key = "<";
        rest = "swap-window -dt -1";
      }
      {
        key = ">";
        rest = "swap-window -dt +1";
      }
      {
        key = "c";
        rest = "new-window -ac \"#{pane_current_path}\"";
      }
      {
        table = "copy-mode-vi";
        key = "DoubleClick1pane";
        rest = "send-keys -X select-word";
      }
      {
        table = "copy-mode-vi";
        key = "TripleClick1pane";
        rest = "send-keys -X select-line";
      }
      {
        comment = "Enter Visual selection with v";
        table = "copy-mode-vi";
        key = "v";
        rest = "send -X begin-selection";
      }
      {
        table = "copy-mode-vi";
        key = "y";
        rest = "send-keys -X copy-pipe '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'";
      }
      {
        table = "copy-mode-vi";
        key = "u";
        rest = "send-keys -X page-up \\; send-keys m";
      }
      {
        table = "copy-mode-vi";
        key = "d";
        rest = "send-keys -X page-down \\; send-keys m";
      }
    ];
}
