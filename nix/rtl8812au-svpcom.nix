{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
  nukeReferences,
}:

stdenv.mkDerivation rec {
  pname = "rtl8812au-svpcom";
  version = "unstable-2025-09-01";

  src = fetchFromGitHub {
    owner = "svpcom";
    repo = "rtl8812au";
    rev = "20bcaf5"; # or pin to latest commit
    sha256 = "sha256-zZT2gCjCWvl5rxOg3cz839hS7JQXkU2K4mvvYK9nO1g=";
  };

  nativeBuildInputs = [
    bc
    nukeReferences
  ]
  ++ kernel.moduleBuildDependencies;
  hardeningDisable = [
    "pic"
    "format"
  ];

  patches = [
    ./patches/rtl8812au-kernel-compat.patch
  ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/" \
      --replace ' O="$(KBUILD_OUTPUT)"' ""

    echo 'EXTRA_CFLAGS += -I$(PWD)' >> Makefile
  '';

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    ("CONFIG_PLATFORM_I386_PC=" + (if stdenv.hostPlatform.isx86 then "y" else "n"))
    ("CONFIG_PLATFORM_ARM_RPI=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  enableParallelBuilding = true;
}
