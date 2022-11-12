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
  echo "Using   C_COMPILER: $CC";
  echo "Using CXX_COMPILER: $CXX";
}

function find_ilink() {
  if [ "$MSYSTEM" = "MINGW64" ]; then
    export ASM=$(cygpath -m $(dirname ${p})/iasm${a});
  else
    export ASM=$(dirname ${p})/iasm${a};
  fi
  echo "Using ASM_COMPILER: $ASM";
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
  rm -rf _build;
  if [ "$MSYSTEM" = "MINGW64" ]; then
    CMAKE_MAKE_PRG=$(cygpath -m $(which ninja));
  else
    CMAKE_MAKE_PRG=$(which ninja);
  fi
  cmake -B_build -G "Ninja" \
    -DCMAKE_MAKE_PROGRAM=$CMAKE_MAKE_PRG;
  if [ $? -ne 0 ]; then
    echo "FAIL: CMake configuration phase.";
    exit 1;
  fi
}

function cmake_build() {
  cmake --build _build --verbose;
  if [ $? -ne 0 ]; then
    echo "FAIL: CMake building phase.";
    exit 1;
  fi
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
  done
done
