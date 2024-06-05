set +o nounset

FLAGS=""

while [[ "$1" =~ ^- ]]; do
    case $1 in
        --daemonize | -f )
            FLAGS="-f"
    esac;
    shift;
done

swaylock $FLAGS
