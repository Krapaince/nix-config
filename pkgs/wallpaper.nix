{ stdenv, fetchzip }:
stdenv.mkDerivation {
  pname = "wallpapers";
  version = "0.0.1";
  src = fetchzip {
    url = "https://www.dropbox.com/scl/fi/kl3812rjgigeh73msdrc7/wallpapers.tar";
    sha256 = "sha256-qe1ke+TVZqucImFVYhzp098Yr1maUx4oze7bgWPpGvE=";
    curlOpts =
      "-GL -d dl=1 -d st=cl4uccir -d e=1 -d rlkey=zg1ncf3oxji5zjk4tth3w0ly8";
  };
  installPhase = ''
    mkdir -p $out
    mv *.png $out/
  '';
}
