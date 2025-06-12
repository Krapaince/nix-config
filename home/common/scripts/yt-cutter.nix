{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      (writeShellApplication {
        name = "yt-cutter";
        runtimeInputs = [ yt-dlp ];
        text = ''
          set -eu

          # https://www.reddit.com/r/youtubedl/wiki/howdoidownloadpartsofavideo/

          URL="$1"
          FROM="$2"
          TO="$3"
          NAME="$4"

          yt-dlp \
            -f "(bestvideo+bestaudio/best)[protocol!*=dash]" \
            --force-overwrites \
            --force-keyframes-at-cut \
            --download-sections "*$FROM-$TO" \
            "$URL" \
            -o "$NAME.webm"
        '';
      })
    ];
}
