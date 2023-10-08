final: prev:
let
  llvmSrc = final.fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "8f966cedea594d9a91e585e88a80a42c04049e6c";
    sha256 = "sha256-g2cYk3/iyUvmIG0QCQpYmWj4L2H4znx9KbuA5TvIjrc=";
  };

  # nix cc-wrapper will add --gcc-toolchain to clang flags. However, when we want to use
  # our custom libc and compilerrt, clang will only search these libs in --gcc-toolchain
  # folder. To avoid this weird behavior of clang, we need to remove --gcc-toolchain options
  # from cc-wrapper
  my-cc-wrapper = final.callPackage
    (
      { llvmPackages_16, runCommand, gccForLibs }:
      let cc = llvmPackages_16.clang; in runCommand "my-cc-wrapper" { } ''
        mkdir -p "$out"
        cp -rT "${cc}" "$out"
        chmod -R +w "$out"
        sed -i 's/--gcc-toolchain=[^[:space:]]*//' "$out/nix-support/cc-cflags"
        sed -i 's|${cc}|${placeholder "out"}|g' "$out"/bin/* "$out"/nix-support/*
        cat >> $out/nix-support/setup-hook <<-EOF
          export NIX_LDFLAGS_FOR_TARGET="$NIX_LDFLAGS_FOR_TARGET -L${gccForLibs.lib}/lib"
        EOF
      ''
    )
    { };

  rv32-clang = final.callPackage
    (
      { my-cc-wrapper, rv32-compilerrt, rv32-musl, runCommand, runtimeShell }:
      runCommand "rv32-clang" {} ''
        mkdir -p $out/bin

        mkWrapper() {
          local filename=$1; shift
          local exec=$1; shift

          echo "#!${runtimeShell}" > $out/bin/$filename
          echo "$exec --target=riscv32 -fuse-ld=lld -L${rv32-compilerrt}/lib/riscv32 -L${rv32-musl}/lib \"\$@\"" > $out/bin/$filename
          chmod +x $out/bin/$filename
        }

        mkWrapper rv32-clang ${my-cc-wrapper}/bin/clang
        mkWrapper rv32-clang++ ${my-cc-wrapper}/bin/clang++
      ''
    )
    { };
in
{
  rv32-compilerrt = final.callPackage ./rv32-compilerrt.nix { inherit llvmSrc; };
  rv32-musl = final.callPackage ./rv32-musl.nix { };
  rv32-libcxx = final.callPackage ./rv32-libcxx.nix { inherit llvmSrc; };
  inherit my-cc-wrapper rv32-clang;
}
