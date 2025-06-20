{ pkgs, ... }:
with pkgs;
writeShellApplication {
  name = "gsettings2";
  runtimeInputs = [ glib ];
  # https://github.com/NixOS/nixpkgs/issues/33277#issuecomment-354689755
  text = ''
    cache_dir="$HOME/.cache/gsettings-schemas"
    cache_file="$cache_dir/cache"
    build_id_file="$cache_dir/build_id"
    build_id="$(grep BUILD_ID /etc/os-release | cut -d '"' -f 2)"
    mkdir -p "$cache_dir"

    if [[ ! -f "$cache_file" ]] || { [[ -f "$build_id_file" ]] && [[ "$(cat "$build_id_file")" != "$build_id" ]]; }; then
      schemas=""
      for p in $NIX_PROFILES; do
        if [[ -d "$p" ]]; then
          for d in $(nix-store --query --references "$p"); do
            schemas_dir=$(echo "$d"/share/gsettings-schemas/*)
            if [[ -d "$schemas_dir/glib-2.0/schemas" ]]; then
              schemas="$schemas''${schemas:+:}$schemas_dir"
            fi
          done
        fi
      done
      echo -n "$schemas" > "$cache_file"
      echo -n "$build_id" > "$build_id_file"
    fi

    env XDG_DATA_DIRS="$(cat "$cache_file")" gsettings "$@"
  '';
}
