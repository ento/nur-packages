{ lib, buildGoModule, fetchFromGitHub, ... }:

let version = "2.7.2"; in

buildGoModule {
  pname = "abs";
  inherit version;

  src = fetchFromGitHub {
    owner = "abs-lang";
    repo = "abs";
    rev = "${version}";
    sha256 = "sha256-lzJxq+bb4lORvAYzuO4O+vNmUbEbgXeLhU5JF42nCHM=";
  };

  vendorHash = "sha256-C0373tZuGkoe5y1PgPtzaT/CeCFLqIEMPU2Kgki5ANk=";

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    # skip some tests
    substituteInPlace util/check_update_test.go \
      --replace \
      'func TestUpdateAvailable(t *testing.T) {' \
      'func TestUpdateAvailable(t *testing.T) {  t.Skip("Skipping test that requires internet access");'

    # taken from the project's .travis.yml
    export CONTEXT=abs
    go test `go list ./... | grep -v "/js"` -vet=off
    runHook postCheck
  '';

  meta = {
    description = "ABS programming language: the joy of shell scripting.";
    homepage = https://github.com/abs-lang/abs;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
}
