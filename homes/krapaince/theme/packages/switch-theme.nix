{
  writeShellApplication,
  lib,
  themeSwitchHooks,
  gsettings2,
  ...
}:
writeShellApplication {
  name = "switch-theme";
  runtimeInputs = [ gsettings2 ];
  text =
    let
      hooksToScript = theme: lib.concatMapStringsSep "\n" (path: "  ${builtins.toString path} ${theme}");
    in
    ''
      if [[ "$(gsettings2 get org.gnome.desktop.interface color-scheme)" == "'prefer-light'" ]]; then
        gsettings2 set org.gnome.desktop.interface color-scheme 'prefer-dark'
      ${hooksToScript "dark" themeSwitchHooks}
      else
        gsettings2 set org.gnome.desktop.interface color-scheme 'prefer-light'
      ${hooksToScript "light" themeSwitchHooks}
      fi
    '';
}
