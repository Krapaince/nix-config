{
  writeShellApplication,
  pkgs,
  lib,
  config,
  ...
}:
writeShellApplication {
  name = "switch-theme";
  runtimeInputs = with pkgs; [ gsettings2 ];
  text =
    let
      hooksToScript = theme: lib.concatMapStringsSep "\n" (path: "${builtins.toString path} ${theme}");
    in
    ''
      if [[ "$(gsettings2 get org.gnome.desktop.interface color-scheme)" == "'prefer-light'" ]]; then
        gsettings2 set org.gnome.desktop.interface color-scheme 'prefer-dark'
        gsettings2 set org.gnome.desktop.interface gtk-theme 'Orchis-Red-Dark'
        ${hooksToScript "dark" config.switchTheme.hooks}
      else
        gsettings2 set org.gnome.desktop.interface color-scheme 'prefer-light'
        gsettings2 set org.gnome.desktop.interface gtk-theme 'Orchis-Red-Light'
        ${hooksToScript "light" config.switchTheme.hooks}
      fi
    '';
}
