{ llvmSrc, llvmPackages_14, cmake, python3,  ninja, rv32-musl }:

llvmPackages_14.stdenv.mkDerivation {
  sourceRoot = "${llvmSrc.name}/runtimes";
  pname = "rv32-libcxx";
  src = llvmSrc;
  version = "unstable-2023-10-08";
  nativeBuildInputs = [ cmake ninja python3 llvmPackages_14.bintools ];
  preConfigure = ''
    cmakeFlagsArray+=("-DCMAKE_C_FLAGS=-w -nostdlib -nostdinc -I${rv32-musl}/include -nodefaultlibs -fno-exceptions -mno-relax -Wno-macro-redefined -fPIC -Wnoundef")
    cmakeFlagsArray+=("-DCMAKE_CXX_FLAGS=-w -nostdlib -nostdinc -I${rv32-musl}/include -nodefaultlibs -fno-exceptions -mno-relax -Wno-macro-redefined -fPIC")
  '';
  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=libcxx;libcxxabi;libunwind"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY"
    "-DCMAKE_SIZEOF_VOID_P=8"

    # "-DCMAKE_SYSTEM_NAME=Generic"
    # "-DCMAKE_SYSTEM_PROCESSOR=riscv32"
    "-DCMAKE_ASM_COMPILER_TARGET=riscv32-none-elf"
    "-DCMAKE_C_COMPILER_TARGET=riscv32-none-elf"
    "-DCMAKE_CXX_COMPILER_TARGET=riscv32-none-elf"

    "-DCMAKE_C_COMPILER_WORKS=ON"
    "-DCMAKE_CXX_COMPILER_WORKS=ON"

    "-DCMAKE_C_COMPILER=/nix/store/mb71f22xl992y288wb1p7v5z6blqj10k-clang-14.0.6/bin/clang"
    "-DCMAKE_CXX_COMPILER=/nix/store/mb71f22xl992y288wb1p7v5z6blqj10k-clang-14.0.6/bin/clang++"

    "-DLIBCXX_ENABLE_SHARED=OFF"
    "-DLIBCXX_ENABLE_THREADS=OFF"
    "-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON"
    "-DLIBCXX_ENABLE_LOCALIZATION=OFF"
    "-DLIBCXX_ENABLE_MONOTONIC_CLOCK=OFF"
    "-DLIBCXX_USE_COMPILER_RT=ON"
    "-DLIBCXX_HAS_MUSL_LIBC=ON"

    "-DLIBCXXABI_ENABLE_SHARED=OFF"
    "-DLIBCXXABI_ENABLE_EXCEPTIONS=OFF"
    "-DLIBCXXABI_USE_LLVM_UNWINDER=ON"
    "-DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON"
    "-DLIBCXXABI_ENABLE_THREADS=OFF"
    "-DLIBCXXABI_BAREMETAL=ON"

    "-DLIBUNWIND_ENABLE_SHARED=OFF"
    "-DLIBUNWIND_IS_BAREMETAL=ON"
    "-DLIBUNWIND_ENABLE_THREADS=OFF"
    "-DLIBUNWIND_INCLUDE_TESTS=OFF"
    "-DLIBUNWIND_REMEMBER_HEAP_ALLOC=ON"
    "-DLIBUNWIND_ENABLE_ASSERSION=OFF"

    "-Wno-dev"
  ];
  env = {
    NIX_DEBUG = 1;
  };
}

