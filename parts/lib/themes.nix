{ lib, ... }:
let
  mkThemeSwitchHook =
    { pkgs, program, ... }@args:
    let
      inherit (lib) getExe;
      name = "switch-theme-${program}";
    in
    getExe (
      pkgs.writeShellApplication {
        inherit (args) runtimeInputs text;
        inherit name;
        meta.mainProgram = name;
      }
    );

  mkThemeSwitchHookConf =
    {
      pkgs,
      config,
      program,
      themeFilepath ? null,
      themeFilename ? null,
      darkTheme,
      lightTheme,
      enable ? true,
    }:
    let
      inherit (lib) isString;

      theme =
        if isString themeFilepath then
          themeFilepath
        else
          "${config.xdg.configHome}/${program}/${themeFilename}";
    in
    {
      xdg.configFile."${program}/dark-theme" = darkTheme;
      xdg.configFile."${program}/light-theme" = lightTheme;

      theme.switch.hooks = lib.lists.optionals enable [
        (mkThemeSwitchHook {
          inherit pkgs program;
          runtimeInputs = [ pkgs.coreutils ];
          text = ''
            function link_theme_file {
                local cfg_dir="${config.xdg.configHome}/${program}"
                local theme="${theme}"

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
                echo "Not light nor dark for ${program} hmmmm"
                exit 1
                ;;
            esac
          '';
        })
      ];
    };
in
{
  inherit mkThemeSwitchHook mkThemeSwitchHookConf;
}
