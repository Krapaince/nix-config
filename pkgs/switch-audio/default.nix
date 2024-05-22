{ pkgs, fetchzip, lib, makeWrapper }:
pkgs.stdenv.mkDerivation rec {
  pname = "switch-audio";
  version = "2023-07-30";
  src = fetchzip {
    url =
      "https://gist.github.com/jkcdarunday/617a0f6662726bd85a71e72969c54128/archive/baffb6f4cc405470de761b1007df3cbba09cc152.zip";
    hash = "sha256-OaGMSrE2KXirQLnKl9a6RyHjofXEpsjbeadliBTNMj0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with pkgs; [ pulseaudio gnugrep gnused coreutils gawk ];

  postFixup = ''
    wrapProgram "$out/bin/switch-audio.sh" --set PATH ${
      lib.makeBinPath buildInputs
    }
  '';

  installPhase = ''
    install -Dm755 ./switch-audio.sh "$out/bin/switch-audio.sh"
  '';

  meta = {
    description =
      "A shell script that switches to the next available Pulseaudio/Pipewire Pulse output device/sink ";
    mainProgram = "switch-audio.sh";
  };
}
