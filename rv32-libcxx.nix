{ llvmSrc, llvmPackages_14, cmake, python3, glibc_multi, ninja,  rv32-musl  }:

llvmPackages_14.stdenv.mkDerivation {
  sourceRoot = "${llvmSrc.name}/runtimes";
  pname = "rv32-libcxx";
  src = llvmSrc;
  version = "unstable-2023-10-08";
  nativeBuildInputs = [ cmake ninja python3 glibc_multi llvmPackages_14.bintools ];
  preConfigure = ''
    cmakeFlagsArray+=("-DCMAKE_C_FLAGS=-I${rv32-musl}/include -nodefaultlibs -fno-exceptions -mno-relax -Wno-macro-redefined -fPIC")
    cmakeFlagsArray+=("-DCMAKE_CXX_FLAGS=-I${rv32-musl}/include -nodefaultlibs -fno-exceptions -mno-relax -Wno-macro-redefined -fPIC")
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

    "-DCMAKE_C_COMPILER=clang"
    "-DCMAKE_CXX_COMPILER=clang++"

    "-DLIBCXX_ENABLE_SHARED=OFF"
    "-DLIBCXX_ENABLE_THREADS=OFF"
    "-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON"
    "-DLIBCXX_ENABLE_LOCALIZATION=OFF"
    "-DLIBCXX_ENABLE_MONOTONIC_CLOCK=OFF"
    "-DLIBCXX_USE_COMPILER_RT=ON"
    "-DLIBCXX_HAS_MUSL_LIBC=ON"

    "-DLIBCXXABI_ENABLE_SHARED=OFF"
    "-DLIBCXXABI_ENABLE_EXCEPTIONS=OFF"
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
}

