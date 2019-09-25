{ stdenv, abs, dhall-json, entr, nodejs }:
stdenv.mkDerivation rec {
  name = "tw5-devtools";
  src = ./.;
  propagatedBuildInputs = [ abs dhall-json entr nodejs ];
  installPhase = ''
    mkdir -p $out/bin $out/lib
    install -m 644 tw5.abs $out/lib/
    install tw5-serve $out/bin
    install tw5-test $out/bin
    install tw5-update-packages $out/bin
  '';
}
