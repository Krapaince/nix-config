{ lib, pkgs, ... }:
let
  inherit (builtins) isString;
  inherit (lib) filter concatStringsSep concatMapStringsSep;
in
{
  alacritty =
    let
      mkBindWithPrefix = prefix: mods: key: char: {
        inherit key mods;
        chars = "${prefix}${char}";
      };
      mkBind = mkBindWithPrefix "\\u0002";
    in
    [
      # Move window
      (mkBind "Super|Shift" "<" "<")
      (mkBind "Super|Shift" ">" ">")

      # Resize pane
      (mkBind "Control|Shift" "h" "\\u001b[1;5D")
      (mkBind "Control|Shift" "j" "\\u001b[1;5B")
      (mkBind "Control|Shift" "k" "\\u001b[1;5A")
      (mkBind "Control|Shift" "l" "\\u001b[1;5C")

      # Force close pane
      (mkBind "Super" "w" "x")

      # Move between panes
      # https://github.com/alacritty/alacritty/issues/474#issuecomment-2137353585
      (mkBind "Super" "h" "\\u001b[D")
      (mkBind "Super" "j" "\\u001b[B")
      (mkBind "Super" "k" "\\u001b[A")
      (mkBind "Super" "l" "\\u001b[C")

      # Split pane H/V
      (mkBind "Control|Alt" "Return" "%")
      (mkBind "Control" "Return" "\"")

      # New/Previous/Next Window
      (mkBind "Super|Shift" "t" "c")
      (mkBind "Super|Shift" "h" "p")
      (mkBind "Super|Shift" "l" "n")
      (mkBind "Super|Shift" "q" "\\u0026")
    ];

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
