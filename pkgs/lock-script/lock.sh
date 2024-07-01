set +o nounset

FLAGS=""

while [[ "$1" =~ ^- ]]; do
    case $1 in
        --daemonize | -f )
            FLAGS="-f"
    esac;
    shift;
done

WALLPAPERS=""
if [[ -n "$(pgrep wpaperd)" ]]; then
  # If a wallpaper path have any space it will not work
  # as bash when expanding $WALLPAPERS will cut the path into multiple arguments
  WALLPAPERS="$(wpaperctl all-wallpapers | sed -e 's/ //' | awk '{print "-i " $0}' | tr '\n' ' ')"
fi

# shellcheck disable=SC2086
swaylock $FLAGS $WALLPAPERS
