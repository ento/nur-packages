{ lib, buildGoModule, fetchFromGitHub, ... }:

let version = "2.3.0"; in

buildGoModule {
  pname = "abs";
  inherit version;

  src = fetchFromGitHub {
    owner = "abs-lang";
    repo = "abs";
    rev = "${version}";
    # You can get this value by running:
    # nix-prefetch-url --unpack --type sha256 https://github.com/abs-lang/abs/archive/${version}.tar.gz
    #sha256 = lib.fakeSha256;
    sha256 = "1faszdc6fjbhybyszh0287ymjfygi3p5rvcv8rzj622wf53yqkra";
  };

  # Use this line to use a fake sha when updating to a new version:
  #vendorSha256 = lib.fakeSha256;
  vendorSha256 = "0waawwbz6mmr9vv1qil59x1v6803zlpc0ls9mdxc6fbip4mrwicp";

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
