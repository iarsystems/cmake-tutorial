#!/bin/bash

# Copyright (c) 2022 IAR Systems AB
#
# Test CMake with the IAR Build Tools
#
# See LICENSE for detailed license information
#

# Environment variables that can be set for this script
# IAR_TOOL_ROOT
#   Top-level location in which the IAR toolchains are installed
#   MINGW64: with the full path (e.g.,) `/c/IAR_Systems/`
#   Default: /opt/iarsystems
# IAR_LMS2_SERVER_IP
#   If defined, automatic license setup will be performed

BUILD_CFGS=(Debug RelWithDebInfo Release MinSizeRel)

if [ -z $IAR_TOOL_ROOT ]; then
  IAR_TOOL_ROOT=/opt/iarsystems
fi

function lms2-setup() {
  if [ ! -z $IAR_LMS2_SERVER_IP ]; then
    LLM=$(dirname ${p})/../../common/bin/LightLicenseManager;
    if [ -f $LLM ]; then
      HAS_SETUP=$(${LLM} | grep setup);
      if [ ! -z $HAS_SETUP ]; then
        SETUP_CMD=setup;
      else
        SETUP_CMD="";
      fi
      $LLM $SETUP_CMD -s $IAR_LMS2_SERVER_IP;
    fi
  fi
}


function find_icc() {
  if [ "$MSYSTEM" = "MINGW64" ]; then
    export CC=$(cygpath -m "${p}");
    export CXX=$CC;
  else
    export CC="${p}";
    export CXX="${p}";
  fi
  echo "Using  CC: $CC";
  echo "Using CXX: $CXX";
}

function find_ilink() {
  if [ "$MSYSTEM" = "MINGW64" ]; then
    export ASM=$(cygpath -m $(dirname ${p})/iasm${a});
  else
    export ASM=$(dirname ${p})/iasm${a};
  fi
  echo "Using ASM: $ASM";
}

function find_xlink() {
  if [ "$MSYSTEM" = "MINGW64" ]; then
    export ASM=$(cygpath -m $(dirname ${p})/a${a});
  else
    export ASM=$(dirname ${p})/a${a};
  fi
  echo "Using ASM_COMPILER: $ASM";
}

function cmake_configure() {
  rm -rf _builds;
  if [ "$MSYSTEM" = "MINGW64" ]; then
    CMAKE_MAKE_PRG=$(cygpath -m $(which ninja));
  else
    CMAKE_MAKE_PRG=$(which ninja);
  fi
  if [ ! $CMAKE_MAKE_PRG ]; then
    echo "FATAL ERROR: Ninja not found.";
    exit 1;
  fi
  cmake -B _builds -G "Ninja Multi-Config" \
    -DCMAKE_MAKE_PROGRAM=$CMAKE_MAKE_PRG;
  if [ $? -ne 0 ]; then
    echo "FAIL: CMake configuration phase.";
    exit 1;
  fi
}

function cmake_build() {
  for cfg in ${BUILD_CFGS[@]}; do
    cmake --build _builds --config ${cfg} --verbose;
    if [ $? -ne 0 ]; then
      echo "FAIL: CMake building phase.";
      exit 1;
    fi
  done
}

function check_elf() {
  for elf in ${BUILD_CFGS[@]}; do
    if [ -f _builds/${cfg}/test-c.elf ]; then
      echo "${elf}: C  ELF built successfully.";
    else
      echo "${elf}: C  ELF not built.";
    fi
    if [ -f _builds/${cfg}/test-cxx.elf ]; then
      echo "${elf}:CXX ELF built successfully.";
    else
      echo "${elf}:CXX ELF not built.";
    fi
    if [ -f _builds/${cfg}/test-asm.elf ]; then
      echo "${elf}:ASM ELF built successfully.";
    else
      echo "${elf}:ASM ELF not built.";
    fi
  done
}

echo "----------- ilink tools";
ILINK_TOOL=(arm riscv rh850 rl78 rx stm8);
for a in ${ILINK_TOOL[@]}; do
  for p in $(find $IAR_TOOL_ROOT -type f -executable -name icc${a}); do
    find_icc;
    find_ilink;
    lms2-setup;
    cmake_configure;
    cmake_build;
    check_elf;
  done
done

echo "----------- xlink tools";
XLINK_TOOL=(8051 430 avr);
for a in ${XLINK_TOOL[@]}; do
  for p in $(find $IAR_TOOL_ROOT -type f -executable -name icc${a}); do
    find_icc;
    find_xlink;
    lms2-setup;
    cmake_configure;
    cmake_build;
    check_elf;
  done
done
