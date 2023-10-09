final: prev:
let
  llvmSrc = final.fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "8f966cedea594d9a91e585e88a80a42c04049e6c";
    sha256 = "sha256-g2cYk3/iyUvmIG0QCQpYmWj4L2H4znx9KbuA5TvIjrc=";
  };
in
{
  rv32-compilerrt = final.callPackage ./rv32-compilerrt.nix { inherit llvmSrc; };
  rv32-musl = final.callPackage ./rv32-musl.nix { };
  rv32-libcxx = final.callPackage ./rv32-libcxx.nix { inherit llvmSrc; };
}
