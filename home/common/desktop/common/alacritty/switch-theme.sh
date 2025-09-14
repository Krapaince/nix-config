function link_theme_file {
    local cfg_dir="$HOME/.config/alacritty"
    local theme="$cfg_dir/theme.toml"

    if [[ -h "$theme" ]]; then
      unlink "$theme"
    fi

    ln -s "$cfg_dir/$1-theme.toml" "$theme"
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
