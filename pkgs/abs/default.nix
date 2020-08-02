{ lib, buildGoModule, fetchFromGitHub, ... }:

let version = "2.2.2"; in

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
    sha256 = "15h51x58myvysn3fdkia87wznrr2g9zn0wv7mdqaczvpz3zl4xva";
  };

  # Use this line to use a fake sha when updating to a new version:
  #vendorSha256 = lib.fakeSha256;
  vendorSha256 = "0waawwbz6mmr9vv1qil59x1v6803zlpc0ls9mdxc6fbip4mrwicp";

  meta = {
    description = "ABS programming language: the joy of shell scripting.";
    homepage = https://github.com/abs-lang/abs;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
}
