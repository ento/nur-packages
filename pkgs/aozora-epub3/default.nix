{ stdenv, lib, fetchFromGitHub, ant, jre, jdk, makeWrapper }:
stdenv.mkDerivation rec {
  pname = "AozoraEpub3";
  version = "1.1.0b55Q";
  src = fetchFromGitHub {
    owner = "kyukyunyorituryo";
    repo = "AozoraEpub3";
    rev = version;
    sha256 = "0pgfj50sqj3nbpx5gzqmancq4lsrwb6vr7kwmjj3pbvdvr7mgfwc";
  };

  nativeBuildInputs = [ jdk ant makeWrapper ];
  patches = [
    # Improve cross-platform support
    ./class-path-separator.patch
    # Initialize Velocity's FileResourceLoader so that templates get resolved correctly
    # See: https://stackoverflow.com/a/37738136
    ./resource-loader-path.patch
  ];

  buildPhase = ''
    mkdir bin
    ${jdk}/bin/javac -cp "src:lib/*" -d bin -encoding UTF-8 src/AozoraEpub3.java
    substituteInPlace ant.xml \
      --replace AozoraEpub3Applet AozoraEpub3
    ant -f ant.xml \
      -Ddir.workspace='.' \
      -Ddir.jarfile='./dist'
  '';
  installPhase = ''
    mkdir -p $out/bin $out/share/${pname}
    cp -r dist/* $out/share/${pname}/

    # NOTE: the package jar path needs to come first, as AozoraEpub3 assumes
    # that to be the case.
    class_path="$out/share/${pname}/AozoraEpub3.jar:$out/share/${pname}/lib/*"
    makeWrapper ${jre}/bin/java $out/bin/aozora-epub3 \
      --set CLASSPATH "$class_path" \
      --add-flags "AozoraEpub3"
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/aozora-epub3 --help
  '';

  meta = with lib; {
    description = "Tool to convert Aozora Bunko books to epub3";
    license = licenses.gpl3;
    homepage = https://w.atwiki.jp/hmdev/;
    maintainers = [];
    platforms = platforms.unix ++ platforms.darwin ++ platforms.windows;
  };
}
