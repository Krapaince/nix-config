{ pkgs, lib, makeWrapper, fetchurl, imagemagick, bc }:
pkgs.stdenv.mkDerivation rec {
  pname = "colorbalance2";
  name = "colorbalance2";
  version = "2018-12-15";
  src = fetchurl {
    url =
      "http://www.fmwconcepts.com/imagemagick/downloadcounter.php?scriptname=colorbalance2&dirname=colorbalance2";
    sha256 = "sha256-eejU4aS2cFDGC2Tu7lQOWUAQwfBkgx84f9y/WoBvfiY=";
    executable = true;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -Dm 0755 "$src" "$out/bin/${pname}"

    wrapProgram "$out/bin/${pname}" --prefix PATH ':' "${
      lib.makeBinPath [ bc imagemagick ]
    }"
  '';

  meta = {
    description =
      "A script to manually color balances an image in midtones, highlights, or shadows.";
    downloadPage =
      "http://www.fmwconcepts.com/imagemagick/colorbalance2/index.php";
    homepage = "http://www.fmwconcepts.com/imagemagick/colorbalance2/index.php";
    mainProgram = pname;
  };
}
