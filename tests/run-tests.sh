#!/bin/bash

# Copyright (c) 2022 IAR Systems AB
#
# Test CMake with the IAR Build Tools
#
# See LICENSE for detailed license information
#

# Update to where all your toolchains are installed
TOOL_ROOT=/c/IAR_Systems/EW

# LMS2 server IP (set to perform)
LMS2_SERVER=

# Check MINGW64
if [ ! "$MSYSTEM" = "MINGW64" ]; then
    echo "This script was designed for MSYS2 (MINGW64)."
    echo "From e.g., https://gitforwindows.org"
    exit 1
fi

function lms2-setup() {
  if [ ! -z $LMS2_SERVER ]; then 
    LLM=$(dirname ${p})/../../common/bin/LightLicenseManager; \
    if [ -f $LLM ]; then
      HAS_SETUP=$(${LLM} | grep setup);
      if [ ! -z $HAS_SETUP ]; then
        SETUP_CMD=setup;
      else
        SETUP_CMD="";
      fi
      $LLM $SETUP_CMD -s $LMS2_SERVER; \
    fi
  fi
}

echo "----------- ilink tools"
ILINK_TOOL=(arm riscv rh850 rl78 rx stm8)
for a in ${ILINK_TOOL[@]}; do \
  for p in $(find $TOOL_ROOT -type f -executable -name icc${a}.exe); do \
    export C_COMPILER=$(cygpath -m "${p}"); \
    echo "Found   C_COMPILER: $C_COMPILER"; \
    export ASM_COMPILER=$(cygpath -m $(dirname ${p})/iasm${a}.exe); \
    echo "Found ASM_COMPILER: ${ASM_COMPILER}"; \
    lms2-setup; \
    rm -rf _build; \
    cmake --toolchain iar-toolchain.cmake -B_build -G "Ninja" \
      -DCMAKE_MAKE_PROGRAM=$(cygpath -m $(which ninja));
  done
done

echo "----------- xlink tools"
XLINK_TOOL=(8051 430 avr)
for a in ${XLINK_TOOL[@]}; do \
  for p in $(find $TOOL_ROOT -type f -executable -name icc${a}.exe); do \
    export C_COMPILER=$(cygpath -m "${p}"); \
    echo "Found   C_COMPILER: $C_COMPILER"; \
    export ASM_COMPILER=$(cygpath -m $(dirname ${p})/a${a}.exe); \
    echo "Found ASM_COMPILER: ${ASM_COMPILER}"; \
    lms2-setup; \
    rm -rf _build; \
    cmake --toolchain iar-toolchain.cmake -B_build -G "Ninja" \
      -DCMAKE_MAKE_PROGRAM=$(cygpath -m $(which ninja));
  done
done
