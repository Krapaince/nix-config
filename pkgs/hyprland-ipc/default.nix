{ pkgs, lib, makeWrapper }:
pkgs.stdenv.mkDerivation rec {
  pname = "hyprland-ipc";
  version = "1.0.0";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with pkgs; [ python3 socat hyprland ];

  src = ./src;

  postFixup = ''
    wrapProgram "$out/bin/hyprland-ipc.sh" --set PATH ${
      lib.makeBinPath buildInputs
    } --set DERIVATION_PATH "$out/bin"
  '';

  installPhase = ''
    install -Dm755 ./hyprland-ipc.sh "$out/bin/hyprland-ipc.sh"
    cp ./hyprland-ipc.py "$out/bin/"
  '';
}
