# Toolchain File for the IAR C/C++ Compiler

# "Generic" is used when cross compiling
set(CMAKE_SYSTEM_NAME Generic)

# Avoids running the linker during try_compile()
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Action: Set the `<arch>` to the compiler's target architecture
# Examples: 430, 8051, arm, avr, riscv, rx, rl78, rh850, stm8 or v850
set(CMAKE_SYSTEM_PROCESSOR <arch>)

# Action: Set the `IAR_INSTALL_DIR` to the tool installation path
set(IAR_INSTALL_DIR <path-to>/<embedded-workbench-installation-dir>)

# Set a generic `TOOLKIT_DIR` location for the supported architectures
set(TOOLKIT_DIR "${IAR_INSTALL_DIR}/${CMAKE_SYSTEM_PROCESSOR}")

# Add the selected IAR toolchain to the PATH (only while CMake is running)
if(UNIX)
  set(ENV{PATH} "${TOOLKIT_DIR}/bin:$ENV{PATH}")
else()
  set(ENV{PATH} "${TOOLKIT_DIR}/bin;$ENV{PATH}")
endif()

# CMake requires individual variables for the C Compiler, C++ Compiler and Assembler
set(CMAKE_C_COMPILER    "icc${CMAKE_SYSTEM_PROCESSOR}")
set(CMAKE_CXX_COMPILER  "icc${CMAKE_SYSTEM_PROCESSOR}")
set(CMAKE_ASM_COMPILER "iasm${CMAKE_SYSTEM_PROCESSOR}")
