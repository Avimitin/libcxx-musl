{ fetchFromGitHub, llvmPackages_14, rv32-compilerrt }:
let
  pname = "musl";
  version = "a167b20fd395a45603b2d36cbf96dcb99ccedd60";
  src = fetchFromGitHub {
    owner = "Avimitin";
    repo = "musl-baremetal";
    rev = "12c3bf03432b2309c3c386cd007f863f0c888cd6";
    sha256 = "sha256-SppibMlca3EdTVQbif30MweZ44UhVF/i/rC0KfV96cI=";
  };
in
llvmPackages_14.stdenv.mkDerivation {
  inherit src pname version;
  nativeBuildInputs = [ llvmPackages_14.bintools ];
  configureFlags = [
    "--target=riscv32-none-elf"
    "--enable-static"
    "--syslibdir=${placeholder "out"}/lib"
  ];
  LIBCC = "-lclang_rt.builtins-riscv32";
  CFLAGS = "--target=riscv32 -mno-relax -nostdinc";
  LDFLAGS = "-fuse-ld=lld --target=riscv32 -nostdlib -L${rv32-compilerrt}/lib/riscv32";
  dontDisableStatic = true;
  dontAddStaticConfigureFlags = true;
  NIX_DONT_SET_RPATH = true;
}

