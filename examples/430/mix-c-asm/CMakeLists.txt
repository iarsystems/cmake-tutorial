cmake_minimum_required(VERSION 3.22)

# Set the project name, [description] and [version],
# while enabling its required languages
project(Example1 
  DESCRIPTION "Mixing C and Assembly"
  VERSION 1.0.0
  LANGUAGES C ASM )

# Fallback option for generators other than `Ninja Multi-Config`
if (NOT DEFINED CMAKE_BUILD_TYPE)
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
  $<$<COMPILE_LANGUAGE:C>:--multiplier=16 --dlib_config ${TOOLKIT_DIR}/lib/dlib/dl430fn.h>
  -D__MSP430F149__ )

# Set the linker options for the "mixLanguages" target
target_link_options(mixLanguages PRIVATE
  -f ${TOOLKIT_DIR}/config/linker/lnk430f149.xcl
  ${TOOLKIT_DIR}/lib/dlib/dl430fn.r43
  # The `SHELL:` prefix prevents option de-duplication
  "SHELL:-D_DATA16_HEAP_SIZE=50"
  "SHELL:-D_STACK_SIZE=50"
  "SHELL:-D_DATA20_HEAP_SIZE=50" )

# Optional: test the project with C-SPY
include(../iar-cspy-430.cmake)
iar_cspy_add_test(mixLanguages test_mynum 42)