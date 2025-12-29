# Generated with mix2nix
{
  lib,
  beamPackages,
  overrides ? (x: y: { }),
}:

let
  buildMix = lib.makeOverridable beamPackages.buildMix;

  self = packages // (overrides self packages);

  packages =
    with beamPackages;
    with self;
    {
      jason = buildMix rec {
        name = "jason";
        version = "1.4.1";

        src = fetchHex {
          pkg = "jason";
          version = "${version}";
          sha256 = "fbb01ecdfd565b56261302f7e1fcc27c4fb8f32d56eab74db621fc154604a7a1";
        };

        beamDeps = [ ];
      };

      optimus = buildMix rec {
        name = "optimus";
        version = "0.5.0";

        src = fetchHex {
          pkg = "optimus";
          version = "${version}";
          sha256 = "acfc75b341952d5d1dde8e0550425ecd3b656dfefa1bb4f14aea10005936378a";
        };

        beamDeps = [ ];
      };
    };
in
self
