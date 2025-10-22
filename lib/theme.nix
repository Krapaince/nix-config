lib:
{
  pkgs,
  program,
  themeFilename,
  darkThemeSource,
  lightThemeSource,
  enable ? true,
}:
let
  name = "switch-theme-${program}";
in
{
  xdg.configFile."${program}/dark-theme".source = darkThemeSource;
  xdg.configFile."${program}/light-theme".source = lightThemeSource;

  switchTheme.hooks = lib.lists.optionals enable [
    (lib.getExe (
      pkgs.writeShellApplication {
        inherit name;
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          function link_theme_file {
              local cfg_dir="$HOME/.config/${program}"
              local theme="$cfg_dir/${themeFilename}"

              if [[ -h "$theme" ]]; then
                unlink "$theme"
              fi

              ln -s "$cfg_dir/$1-theme" "$theme"
          }

          case $1 in
            "light" | "dark")
              link_theme_file "$1"
              ;;
            *)
              echo "Not light nor dark hmmmm"
              exit 1
              ;;
          esac
        '';
        meta.mainProgram = name;
      }
    ))
  ];
}
