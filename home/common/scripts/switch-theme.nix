{ pkgs, ... }:
{
  writeShellApplication,
  pkgs,
  ...
}:
writeShellApplication {
  name = "switch-theme";
  runtimeInputs = with pkgs; [ gsettings2 ];
  text = ''
    if [[ "$(gsettings2 get org.gnome.desktop.interface color-scheme)" == "'prefer-light'" ]]; then
      gsettings2 set org.gnome.desktop.interface color-scheme 'prefer-dark'
      gsettings2 set org.gnome.desktop.interface gtk-theme 'Orchis-Red-Dark'
    else
      gsettings2 set org.gnome.desktop.interface color-scheme 'prefer-light'
      gsettings2 set org.gnome.desktop.interface gtk-theme 'Orchis-Red-Light'
    fi
  '';
}
