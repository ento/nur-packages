{ lib, buildGoModule, fetchFromGitHub, ... }:

let version = "1.8.0"; in

buildGoModule {
  pname = "abs";
  inherit version;

  src = fetchFromGitHub {
    owner = "abs-lang";
    repo = "abs";
    rev = "${version}";
    # You can get this value by running:
    # nix-prefetch-url --unpack --type sha256 https://github.com/abs-lang/abs/archive/${version}.tar.gz
    sha256 = "0sspywx3bdjrmvnknr7qp1k3fnbklfjv8psnr3jykpykskqnmyn1";
  };

  goPackagePath = "github.com/abs-lang/abs";

  # Use this line to use a fake sha when updating to a new version:
  #modSha256 = lib.fakeSha256;
  modSha256 = "1yzk734ymdidjpzzyx9i2if12dss041fxp85d1afxqcn8aja6vaz";

  meta = {
    description = "ABS programming language: the joy of shell scripting.";
    homepage = https://github.com/abs-lang/abs;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
}
