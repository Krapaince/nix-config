{
  fetchFromGitHub,
  beamPackages,
  lib,
  makeWrapper,
  erlang,
  colorbalance2,
}:
let
  pname = "wall-gen";
in
beamPackages.mixRelease {
  inherit pname;
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Krapaince";
    repo = pname;
    rev = "f3b2792c23969c380c255b2041a3d69a3ba74ee4";
    hash = "sha256-03ceXm/G2TsZb+Rvy0FNO5frS0zlSyo/BsU8S/NJzpg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  mixNixDeps = import ./deps.nix { inherit lib beamPackages; };

  postBuild = ''
    mix escript.build --no-deps-check
  '';

  installPhase = ''
    install -Dm 0755 ./wall-gen "$out/bin/wall-gen"

    wrapProgram "$out/bin/wall-gen" --prefix PATH ':' "${
      lib.makeBinPath [
        erlang
        colorbalance2
      ]
    }"
  '';
}
