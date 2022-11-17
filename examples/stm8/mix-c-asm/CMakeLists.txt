cmake_minimum_required(VERSION 3.22)

# Set the project name, [description] and [version],
# while enabling its required languages
project(Example1 
  DESCRIPTION "Mixing C and Assembly"
  VERSION 1.0.0
  LANGUAGES C ASM )

# Fallback option for generators other than `Ninja Multi-Config`
if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

# Enable CTest
enable_testing()

# Add the executable for the "mixLanguages" target
add_executable(mixLanguages
  # Source files
  main.c
  mynum.asm )

# Set a preprocessor symbol, usable from "mixLanguages" target
target_compile_definitions(mixLanguages PUBLIC USE_ASM=1)

# Set the compiler flags for the "mixLanguages" target
target_compile_options(mixLanguages PRIVATE
  $<$<COMPILE_LANGUAGE:C>:--vregs 16 --dlib_config ${TOOLKIT_DIR}/lib/dlstm8smn.h>
  --data_model medium --code_model small )

# Set the linker options for the "mixLanguages" target

target_link_options(mixLanguages PRIVATE
  $<$<CONFIG:Debug>:--debug_lib --redirect ___write=___write_buffered>
  --config ${TOOLKIT_DIR}/config/lnkstm8.icf
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:--config_def _CSTACK_SIZE=0x100"
  "SHELL:--config_def   _HEAP_SIZE=0x100" )

# Optional: test the project with CTest and IAR C-SPY
include(../iar-cspy-stm8.cmake)
iar_cspy_add_test(mixLanguages test_mynum 42)