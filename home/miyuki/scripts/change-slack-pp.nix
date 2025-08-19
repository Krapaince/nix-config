{
  pkgs,
  inputs,
  config,
  ...
}:
{
  sops =
    let
      secretsPath = builtins.toString inputs.secrets;
    in
    {
      secrets = {
        "slack/profile-picture-setter".sopsFile = "${secretsPath}/hosts/miyuki.yaml";
      };
    };

  home.packages = with pkgs; [
    (writeShellApplication {
      name = "change-slack-pp";
      runtimeInputs = [
        bc
        imagemagick
        openssl
        curl
      ];
      excludeShellChecks = [ "SC2155" ];
      text = ''
        BACKGROUND_COLOR="#3292ba"

        function random {
          echo $(($1 + RANDOM % $2))
        }

        function prepend_to_filename {
          local file=$(basename "$1")
          local dir=$(dirname "$1")

          echo "$dir/$2-$file"
        }

        function rotate {
          local filename="$1"
          local ratio=$(random 0 11)
          local angle=$(echo "$ratio*30" | bc)
          local output_filename=$(prepend_to_filename "$filename" "rotated")

          magick "$filename" -background "$BACKGROUND_COLOR" -virtual-pixel "background" -distort SRT -"$angle" "$output_filename"
          echo "$output_filename"
        }

        function replace_color {
          local filename="$1"
          local random_color="#$(openssl rand -hex 3)"
          local output_filename=$(prepend_to_filename "$filename" "replaced-color")

          magick "$filename" -fuzz 32% -fill "$random_color" -opaque "$BACKGROUND_COLOR" "$output_filename"
          echo "$output_filename"
        }

        function crop_pp {
          local filename="$1"
          local output_filename=$(prepend_to_filename "$filename" "cropped")
          local offset=30
          local offset_x=150
          local offset_x=$(random $((offset_x - offset)) $((offset_x + offset)))
          local offset_y=100
          local offset_y=$(random $((offset_y - offset)) $((offset_y + offset)))

          magick "$filename" -crop "1024x1024+$offset_x+$offset_y" "$output_filename"
          echo "$output_filename"
        }

        function upload_pp {
          local token="$(<${config.sops.secrets."slack/profile-picture-setter".path})"
          local filename="$1"

          curl 'https://${inputs.secrets.work.company_name}.slack.com/api/users.setPhoto' \
            -X POST \
            --no-progress-meter \
            -H "Authorization: Bearer $token" \
            -H 'Content-Type: multipart/form-data' \
            -F "image=@$filename"
        }

        FILENAME="pp.png"
        BASEDIR="$HOME/Pictures/Avatar"
        TMP_FILENAME="/tmp/$FILENAME"
        OUTPUT_FILENAME="$BASEDIR/slack-pp.png"

        cp "$BASEDIR/$FILENAME" "$TMP_FILENAME"
        FILENAME="$TMP_FILENAME"
        FILENAME=$(rotate "$FILENAME")
        FILENAME=$(replace_color "$FILENAME")
        FILENAME=$(crop_pp "$FILENAME")
        cp "$FILENAME" "$OUTPUT_FILENAME"
        upload_pp "$OUTPUT_FILENAME"
      '';
    })
  ];
}
