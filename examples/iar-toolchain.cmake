# Toolchain File for the IAR C/C++ Compiler

# Action: Set the `<arch>` to the compiler's target architecture
# Examples: 430, 8051, arm, avr, riscv, rx, rl78, rh850, stm8 or v850
set(CMAKE_SYSTEM_PROCESSOR <arch>)

# Action: Set the `IAR_INSTALL_DIR` to the tool installation path
set(IAR_INSTALL_DIR "/path/to/install_dir")

# "Generic" is used when cross compiling
set(CMAKE_SYSTEM_NAME Generic)

# Avoids running the linker during try_compile()
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Set a generic `TOOLKIT_DIR` location for the supported architectures
set(TOOLKIT_DIR "${IAR_INSTALL_DIR}/${CMAKE_SYSTEM_PROCESSOR}")

# Add the selected IAR toolchain to the PATH (only while CMake is running)
if (UNIX)
  set(ENV{PATH} "${TOOLKIT_DIR}/bin:$ENV{PATH}")
else()
  set(ENV{PATH} "${TOOLKIT_DIR}/bin;$ENV{PATH}")
endif()

# CMake requires individual variables for the C, C++ and Assembler
# IAR C/C++ Compiler executable name
set(CMAKE_C_COMPILER    "icc${CMAKE_SYSTEM_PROCESSOR}")
set(CMAKE_CXX_COMPILER  "icc${CMAKE_SYSTEM_PROCESSOR}")
 
# Automatically set the IAR Assembler executable name 
# (depends on the toolchain's linker technology)
list(APPEND _IAR_TOOLCHAINS_ILINK arm riscv rh850 rl78 rx stm8)
if (${CMAKE_SYSTEM_PROCESSOR} IN_LIST _IAR_TOOLCHAINS_ILINK)
  # The Assembler executable for toolchains using the ILINK linker
  set(CMAKE_ASM_COMPILER  "iasm${CMAKE_SYSTEM_PROCESSOR}")
else()
  # The Assembler executable for toolchains using the XLINK linker
  set(CMAKE_ASM_COMPILER  "a${CMAKE_SYSTEM_PROCESSOR}")
endif()
unset(_IAR_TOOLCHAINS_ILINK)
